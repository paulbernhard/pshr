require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/storage/memory'

if Rails.env.test?
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new(Pshr.uploads_dir, prefix: Pshr.uploads_cache_prefix),
    store: Shrine::Storage::FileSystem.new(Pshr.uploads_dir, prefix: Pshr.uploads_store_prefix)
  }
end

Shrine.plugin :activerecord # use ActiveRecord
Shrine.plugin :cached_attachment_data # cache attachment data across request
Shrine.plugin :determine_mime_type, analyzer: :mime_types # determine mime-type (with 'mime-types' gem)
Shrine.plugin :infer_extension, force: true # deduce extension from actual mime-type (with 'mime-types' gem)
Shrine.plugin :store_dimensions, analyzer: :ruby_vips # store dimensions in file metadata
Shrine.plugin :delete_promoted # delete file after promotion
Shrine.plugin :delete_raw unless (Rails.env.development? || Rails.env.test?) # delete raw file after upload
Shrine.plugin :remove_invalid # delete invalid files
# Shrine.plugin :versions # create versions
# Shrine.plugin :processing # process uploaded files
# Shrine.plugin :backgrounding # process in background job
# Shrine.plugin :upload_endpoint # endpoint for XHR uploads