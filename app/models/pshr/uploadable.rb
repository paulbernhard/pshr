module Pshr
  module Uploadable
    extend ActiveSupport::Concern

    included do
      # associations
      belongs_to :uploadable, polymorphic: true

      # include shrine
      include FileUploader::Attachment.new(:file)

      # validation
      validates :file, presence: true

      # hooks
      before_save :set_processing_state, :set_mime_type
    end

    private

      def set_processing_state
        if file_data_changed? && file_attacher.cached?
          self.processing = true
        elsif file_data_changed? && file_attacher.stored?
          self.promoted = false
        end
      end

      def set_mime_type
        debugger
      end
  end
end