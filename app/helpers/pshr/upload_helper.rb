module Pshr
  module UploadHelper

    # reluctant image_tag for upload
    # an optional version can be specified, otherwise first version
    # will be used
    def pshr_image_tag(upload, version: nil, **options)
      file = upload.reluctant_file(version)
      return image_tag(file.url, options)
    end

    # srcset for upload with versions
    # returns srcset for [versions] with width
    def pshr_srcset(upload, versions: [])
      if upload.has_versions? && versions.any?
        return versions.map { |v| "#{upload.file[v].url} #{upload.file[v].metadata['width']}w" }.join(', ')
      else
        return nil
      end
    end

    # image_tag with srcset (with image widths)
    def pshr_srcset_image_tag(upload, versions: [], default: nil, **options)
      src = upload.reluctant_file(default).url
      srcset = pshr_srcset(upload, versions: versions)
      options.merge!({ srcset: srcset }) unless srcset.blank?
      return image_tag(src, options)
    end

    # fields for a nested upload form
    def pshr_upload_fields(form)
      render 'pshr/uploads/fields', form: form
    end

    # uploader for singular uploads
    def pshr_uploader(upload)
      render 'pshr/uploads/uploader', upload: upload
    end

    # upload panel
    def pshr_upload_panel(resource_name: nil, scope: nil, uploads: nil)
      render 'pshr/uploads/upload_panel', resource_name: resource_name, scope: scope, uploads: uploads
    end
  end
end
