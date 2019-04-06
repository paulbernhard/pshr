module Pshr
  module UploadHelper

    def upload_partial(upload)
      file = upload.file
      output = nil
      if has_versions?(file)
        file.map { |k,v| v.url }.join('<br>').html_safe
      else
        file.url.html_safe
      end
    end

    private

      def has_versions?(file)
        file.is_a?(Hash) ? true : false
      end
  end
end