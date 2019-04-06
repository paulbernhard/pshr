require 'image_processing/vips'

module Pshr
  module Processor
    extend self

    def process_image(file)
      pipeline = ImageProcessing::Vips
        .source(file)

      original = pipeline.call
      large = pipeline.resize_to_limit!(2560, 1920)
      medium = pipeline.resize_to_limit!(1920, 1080)
      small = pipeline.resize_to_limit!(1280, 800)

      { original: original,large: large, medium: medium, small: small }
    end

    def process_video(file)
      file
    end
  end
end
