require 'sidekiq'

module Pshr
  class PromoteJob
    include Sidekiq::Worker
    sidekiq_options retry: 1

    sidekiq_retries_exhausted do |msg, ex|
      # destroy record if processing retries are exhausted
      record = args.first['record']
      record.first.constantize.find(record.last.to_i).destroy
    end

    def perform(data)
      # can use attacher object to manipulate record after processing
      # such as: attacher.record.update(published: true)
      attacher = Shrine::Attacher.promote(data)
    end
  end
end
