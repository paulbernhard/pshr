class CustomUpload < ApplicationRecord
  # include Uploadable
  include Pshr::Uploadable

  # set uploading options
  # pshr_with(processors: {},
  #           whitelist: %W(image/jpeg, image/png),
  #           max_file_size: 1.megabyte)
  pshr_set processors: { image: 'Processors::CustomImage' },
            whitelist: %W(image/jpeg image/jpg image/png video/mp4),
            max_file_size: 200.kilobytes

  # serialize metadata column to add custom attributes
  serialize :metadata
  store_accessor :metadata, :caption
end
