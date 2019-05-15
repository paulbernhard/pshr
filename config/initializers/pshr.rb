Pshr.setup do |config|

  # base directory for uploads
  # config.uploads_dir = "public"

  # prefix for uploads folder wihtin config.uploads_dir
  # config.uploads_prefix = "uploads"

  # set a custom processor with hash
  # for example { image: 'Pshr::Processors::Image', video: 'Processors::Video' }
  # fale disables processing
  # config.processors = false

  # process files in background job (requires a redis server and sidekiq!)
  # config.process_in_background = false

  # validation for allowed filetypes as array of mime-types (false disables filetype validation)
  # config.whitelist = false

  # validation for maximum file size (false disables filesize validation)
  # config.max_file_size = false
end
