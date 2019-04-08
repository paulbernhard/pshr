require 'pshr/engine'
require 'jbuilder'
require 'byebug' if (Rails.env.test? || Rails.env.development?)

module Pshr

  # set configuration variables with defaults
  # variables can be overriden with an initializer in host app
  class << self
    mattr_accessor :uploads_dir # upload directory
    self.uploads_dir = "public"

    mattr_accessor :uploads_cache_prefix
    self.uploads_cache_prefix = "uploads/cache"

    mattr_accessor :uploads_store_prefix
    self.uploads_store_prefix = "uploads/store"

    # mattr_accessor :image_processing, :video_processing
    # self.image_processing = false
    # self.video_processing = false

    mattr_accessor :processors
    self.processors = false
    # self.processor = 'Pshr::Processor'

    # TODO processing for audio files
    # TODO processing for document files

    mattr_accessor :process_in_background
    self.process_in_background = false

    mattr_accessor :whitelist
    self.whitelist = false
    # self.whitelist = %W(image/jpg image/jpeg image/png image/gif video/quicktime video/mp4)

    mattr_accessor :max_file_size
    self.max_file_size = false
  end

  # setup in initializer
  def self.setup(&block)
    yield(self)
  end
end
