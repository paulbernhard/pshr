class CustomUpload < ApplicationRecord
  include Pshr::Uploadable
  pshr_with processor: 'CustomProcessor',
            whitelist: %W(image/jpeg image/jpg image/png video/mp4),
            max_file_size: 200.kilobytes
end
