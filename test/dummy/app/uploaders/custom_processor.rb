require 'image_processing/vips'

module CustomProcessor
  extend Pshr::Processor

  def self.process_image(file)
    pipeline = ImageProcessing::Vips
        .source(file)
        .convert('png')

    original = pipeline.call
    original
  end
end
