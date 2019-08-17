$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "pshr/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "pshr"
  spec.version     = Pshr::VERSION
  spec.authors     = ["Paul Bernhard"]
  spec.email       = ["mail@pbernhard.com"]
  spec.homepage    = "http://github.com/paulbernhard/pshr"
  spec.summary     = "pshr - Rails engine for polymorphic uploads (using shrine) with an uploader interface."
  spec.description = "pshr - Rails engine for polymorphic uploads (using shrine) with an uploader interface."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'rails', '~> 6.0.0.rc1'
  spec.add_dependency 'jbuilder', '~> 2.8'

  spec.add_dependency 'tus-server', '~> 2.2', '>= 2.2.1' # tus server for resumable file uploads

  spec.add_dependency 'shrine', '~> 2.16' # shrine file uploader
  spec.add_dependency 'shrine-memory', '~> 0.3.0' # in-memory storage to speed up upload tests
  spec.add_dependency 'shrine-tus', '~> 1.2', '>= 1.2.2' # tus filesystems for shrine
  spec.add_dependency 'marcel', '~> 0.3.3' # mime-type determination
  spec.add_dependency 'fastimage', '~> 2.1', '>= 2.1.5' # mime-type determination

  spec.add_dependency 'redis', '~> 4.1' # redis memory server for background jobs
  spec.add_dependency 'sidekiq', '~> 5.2', '>= 5.2.5' # sidekiq background jobs
  spec.add_dependency 'image_processing', '~> 1.8' # processing wrapper for minimagick/vips

  spec.add_dependency 'ranked-model', '~> 0.4.4' # ordering of upload records

  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'byebug', '~> 11.0', '>= 11.0.1'
end
