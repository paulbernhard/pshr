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
        return versions.map { |v| "#{file[v].url} #{file[v].metadata['width']}w" }.join(', ')
      else
        return nil
      end
    end

    # image_tag with srcset (with image widths)
    def pshr_srcset_image_tag(upload, versions: [], default: nil, **options)
      src = upload.reluctant_file(version)
      srcset = pshr_srcset(upload, versions: versions)
      options.merge!({ srcset: srcset }) unless srcset.blank?
      return image_tag(src, options)
    end
  end
end
