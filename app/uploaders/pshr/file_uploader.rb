require 'sidekiq' if Pshr.process_in_background

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
      whitelist = record.class.whitelist
      max_file_size = record.class.max_file_size

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
      processors = context[:record].class.processors
      if processors && processors[type.to_sym]
        processor = processors[type.to_sym]
        download_and_process(io, processor)
      else
        io
      end
    end

    private

      # download the file and give it to the processor
      def download_and_process(io, processor)
        output = nil
        io.download do |file|
          processor = processor.constantize if processor.is_a?(String)
          output = processor.process(file)
        end
        output
      end
  end
end
