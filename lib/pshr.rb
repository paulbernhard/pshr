require 'pshr/engine'
require 'pshr/routes'
require 'jbuilder'

require 'byebug' if (Rails.env.test? || Rails.env.development?)

module Pshr

  # set configuration variables with defaults
  # variables can be overriden with an initializer in host app
  class << self
    # upload directory (string)
    mattr_accessor :uploads_dir
    self.uploads_dir = "public"

    # prefix for uploads folder wihtin config.uploads_dir (string)
    mattr_accessor :uploads_prefix
    self.uploads_prefix = "uploads"

    # processing on a per-type basis (false / hash)
    # processors = false
    # disables processing
    # processors = { image: Processors::Image, video: Processors::Video }
    # uses custom processors per file type
    #
    # a processor needs a self.process(file) method
    # see pshr/app/uploaders/pshr/processors/*.rb for example processors
    mattr_accessor :processors
    self.processors = false

    # execute file processing in background (boolean)
    # this requires a runnning sidekiq instance
    mattr_accessor :process_in_background
    self.process_in_background = false

    # whitelist for allowed mime-types (array)
    # %W(image/jpg image/gif image/png video/mp4)
    # false allows all file types
    mattr_accessor :whitelist
    self.whitelist = false

    # maximum filesize limit in bytes (integer)
    # false disables limitation
    # can be set to Rails filesize objects
    # 1.megabyte, 2.kilobytes, etc.
    mattr_accessor :max_file_size
    self.max_file_size = false
  end

  # setup in initializer
  def self.setup(&block)
    yield(self)
  end
end
