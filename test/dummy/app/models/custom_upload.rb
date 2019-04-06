class CustomUpload < ApplicationRecord
  # include Uploadable
  include Pshr::Uploadable

  # set uploading options
  # pshr_with(processor: 'Pshr::Processor',
  #           whitelist: %W(image/jpeg, image/png),
  #           max_file_size: 1.megabyte)
  pshr_with processor: 'CustomProcessor',
            whitelist: %W(image/jpeg image/jpg image/png video/mp4),
            max_file_size: 200.kilobytes
end
