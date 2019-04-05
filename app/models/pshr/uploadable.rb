require 'ranked-model'

module Pshr
  module Uploadable
    extend ActiveSupport::Concern

    included do
      # associations
      belongs_to :uploadable, polymorphic: true, optional: true

      # include shrine
      include Pshr::FileUploader::Attachment.new(:file)

      # validation
      validates :file, presence: true

      # hooks
      before_save :set_processing_state, :set_mime_type

      # ranking of uploads rows within associated parent
      include RankedModel
      ranks :order, with_same: [:uploadable_type, :uploadable_id]
    end

    def mime_type
      self.metadata['mime_type']
    end

    def type
      self.mime_type.split('/')[0]
    end

    private

      def set_processing_state
        if file_data_changed? && file_attacher.cached?
          self.processing = true
        elsif file_data_changed? && file_attacher.stored?
          self.processing = false
        end
      end

      # sync with mime-type of file or first version
      def set_mime_type
        file = self.file.is_a?(Hash) ? self.file.first : self.file
        self.metadata['mime_type'] = file.mime_type
      end
  end
end