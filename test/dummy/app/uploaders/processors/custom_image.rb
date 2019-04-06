require 'image_processing/vips'

module Processors::CustomImage

  def self.process(file)
    pipeline = ImageProcessing::Vips
      .source(file)
      .convert("png")

    pipeline.call
  end
end
