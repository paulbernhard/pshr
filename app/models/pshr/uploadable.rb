require 'ranked-model'

module Pshr
  module Uploadable
    extend ActiveSupport::Concern

    included do
      # include shrine functionality and set defaults
      include Pshr::FileUploader::Attachment.new(:file)
      # self.processor = Pshr.processor
      # self.whitelist = Pshr.whitelist
      # self.max_file_size = Pshr.max_file_size

      # include ranking functionality
      include RankedModel
      ranks :order, with_same: [:uploadable_id, :uploadable_type]

      belongs_to :uploadable, polymorphic: true, optional: true

      validates :file, presence: true

      before_save :set_processing_state, :set_mime_type

      scope :ordered, -> { rank(:order) }
    end

    class_methods do
      # accessor for custom settings
      attr_accessor :processors, :whitelist, :max_file_size

      # custom settings for pshr
      # pshr_with(processor: 'Pshr::Processor',
      #           whitelist: %W(image/jpeg, image/png),
      #           max_file_size: 1.megabyte)
      def pshr_with(options = {})
        self.processors = options[:processors].nil? ? Pshr.processors : options[:processors]
        self.whitelist = options[:whitelist].nil? ? Pshr.whitelist : options[:whitelist]
        self.max_file_size = options[:max_file_size].nil? ? Pshr.max_file_size : options[:max_file_size]
      end
    end

    def mime_type
      self.metadata['mime_type']
    end

    def type
      self.mime_type.split('/')[0] if self.mime_type
    end

    def has_versions?
      self.file.is_a?(Hash) ? true : false
    end

    # return file even if the upload has multiple versions
    # optionally a version can be specified
    def reluctant_file(version = nil)
      if self.has_versions?
        version.blank? ? self.file[self.file.keys.first] : self.file[version]
      else
        self.file
      end
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
        self.metadata = {} if self.metadata.nil?
        self.metadata['mime_type'] = self.reluctant_file.mime_type
      end
  end
end
