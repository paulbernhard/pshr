class CustomUpload < ApplicationRecord
  # include Uploadable
  include Pshr::Uploadable

  # set uploading options
  # pshr_with(processors: {},
  #           whitelist: %W(image/jpeg, image/png),
  #           max_file_size: 1.megabyte)
  pshr_with processors: { image: 'Processors::CustomImage' },
            whitelist: %W(image/jpeg image/jpg image/png video/mp4),
            max_file_size: 200.kilobytes
end
