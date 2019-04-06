module Pshr
  class DeleteJob
    include Sidekiq::Worker

    def perform(data)
      # can use attacher object to manipulate record after processing
      # such as: attacher.record.update(published: false)
      attacher = Shrine::Attacher.delete(data)
    end
  end
end
