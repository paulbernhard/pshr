module Pshr
  class FileUploader < Shrine

    # file validation based on initializer settings or
    # custom model settings
    plugin :validation_helpers, default_messages: {
      mime_type_inclusion: -> (whitelist) { I18n.t('shrine.errors.mime_type', whitelist: whitelist.join(', ')) },
      max_size: -> (max) { I18n.t('shrine.errors.max_size', max: max / 1048576.0) }
    }

    Attacher.validate do
      # validate with model validation settings
      whitelist = record.class.pshr_whitelist ? record.class.pshr_whitelist : Pshr.whitelist
      max_file_size = record.class.pshr_max_file_size ? record.class.pshr_max_file_size : Pshr.max_file_size

      validate_mime_type_inclusion whitelist if whitelist
      validate_max_size max_file_size if max_file_size
    end

    # processing in background job
    if Pshr.process_in_background
      Attacher.promote { |data| Pshr::PromoteJob.perform_async(data) }
      Attacher.delete { |data| Pshr::DeleteJob.perform_async(data) }
    end

    process(:store) do |io, context|
      # conditional processing if processing is enabled for type (image, video, …)
      # using Pshr::Processor or a processor defined by Upload model
      type = io.mime_type.split('/')[0]
      processor = context[:record].class.pshr_processor ? context[:record].class.pshr_processor : Pshr.processor
      output = conditional_processing(io, type, processor)
      output
    end

    private

      # return processed file based on type
      # or just io if processing is disabled
      def conditional_processing(io, type, processor)
        if Pshr.send("#{type}_processing")
          download_and_process(io, type, processor)
        else
          io
        end
      end

      def download_and_process(io, type, processor)
        output = nil
        io.download do |file|
          output = processor.constantize.send("process_#{type}", file)
        end
        output
      end
  end
end
