require 'ranked-model'

module Pshr
  module Uploadable
    extend ActiveSupport::Concern

    included do
      # include shrine functionality and set defaults
      include Pshr::FileUploader::Attachment.new(:file)
      # self.pshr_processor = Pshr.processor
      # self.pshr_whitelist = Pshr.whitelist
      # self.pshr_max_file_size = Pshr.max_file_size

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
      attr_accessor :pshr_processors, :pshr_whitelist, :pshr_max_file_size

      # custom settings for pshr
      # pshr_with(processor: 'Pshr::Processor',
      #           whitelist: %W(image/jpeg, image/png),
      #           max_file_size: 1.megabyte)
      def pshr_with(options = {})
        self.pshr_processors = options[:processors] if options[:processors]
        self.pshr_whitelist = options[:whitelist] if options[:whitelist]
        self.pshr_max_file_size = options[:max_file_size] if options[:max_file_size]
      end
    end

    def mime_type
      self.metadata['mime_type']
    end

    def type
      self.mime_type.split('/')[0]
    end

    def hello
      puts "hi"
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
        file = self.file.is_a?(Hash) ? self.file[self.file.keys.first] : self.file
        self.metadata['mime_type'] = file.mime_type
      end
  end
end
