require 'pshr/engine'
require 'byebug'

module Pshr
  
  # set configuration variables with defaults
  # variables can be overriden with an initializer in host app
  class << self
    mattr_accessor :uploads_dir # upload directory
    self.uploads_dir = "uploads"

    mattr_accessor :uploads_cache_prefix
    self.uploads_cache_prefix = "uploads/cache"

    mattr_accessor :uploads_store_prefix
    self.uploads_store_prefix = "uploads/store"

    mattr_accessor :image_processing, :video_processing
    self.image_processing = false
    self.video_processing = false

    # TODO processing for audio files
    # TODO processing for document files

    mattr_accessor :process_in_background
    self.process_in_background = false

    mattr_accessor :whitelist
    self.whitelist = %W(image/jpg image/jpeg image/png image/gif video/quicktime video/mp4)

    mattr_accessor :max_upload_size
    self.max_upload_size = false
  end

  # setup in initializer
  def self.setup(&block)
    yield(self)
  end
end
