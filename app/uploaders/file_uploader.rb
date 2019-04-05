module Pshr
  class FileUploader < Shrine

    # validation
    plugin :validation_helpers, default_messages: {
      mime_type_inclusion: -> (whitelist) { I18n.t('shrine.errors.mime_type', whitelist: whitelist.join(', ')) },
      max_size: -> (max) { I18n.t('shrine.errors.max_size', max: max / 1048576.0) }
    }

    Attacher.validate do
      validate_mime_type_inclusion Pshr.whitelist
      validate_max_size Pshr.max_upload_size if Pshr.max_upload_size
    end

    # processing in background job
    if Pshr.process_in_background
      # Attacher.promote { |data| Pshr::PromoteJob.perform_async(data) }
      # Attacher.delete { |data| Pshr::DeleteJob.perform_async(data) }
    end

    # processing dependent on mime-type
    # can return a hash for versions or single file
    process(:store) do |io, context|
      
      output = io # return io without processing
      type = io.mime_type.split('/')[0]

      if type == 'image' && Pshr.image_processing

        io.download do |file|
          output = Pshr::Processors::Image.process(file, io.mime_type)
        end

      elsif type == 'video' && Pshr.video_processing

        io.download do |file|
          output = Pshr::Processors::Video.process(file, io.mime_type)
        end
      end

      output
    end
  end
end