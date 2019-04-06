module Pshr
  class Upload < ApplicationRecord

    # include Uploadable
    include Pshr::Uploadable

    # set uploading options
    # pshr_with(processor: 'Pshr::Processor',
    #           whitelist: %W(image/jpeg, image/png),
    #           max_file_size: 1.megabyte)
    pshr_with(processor: 'Some processor…')
  end
end
