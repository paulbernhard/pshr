Pshr.setup do |config|

  # configuration for the pshr engine
  # the configuration for processors, whitelist and max_file_size
  # can be set on a per model basis, using the pshr_set method (see docs)

  # base directory for uploads (string)
  # config.uploads_dir = "public"

  # prefix for uploads folder wihtin config.uploads_dir (string)
  # config.uploads_prefix = "uploads"

  # processing on a per-type basis (boolean / hash)
  # processors = false
  # disables processing
  # processors = { image: Processors::Image, video: Processors::Video }
  # uses custom processors per file type
  # a processor needs a self.process(file) method
  # see pshr/app/uploaders/pshr/processors/*.rb for example processors
  # config.processors = false

  # execute file processing in background (boolean)
  # this requires a runnning sidekiq instance
  # config.process_in_background = false

  # whitelist for allowed mime-types (array)
  # false allows all file types
  # %W(image/jpg image/gif image/png video/mp4)
  # config.whitelist = false

  # maximum filesize limit in bytes (integer)
  # false disables limitation
  # can be set to Rails filesize objects
  # 1.megabyte, 2.kilobytes, etc.
  # config.max_file_size = false
end
