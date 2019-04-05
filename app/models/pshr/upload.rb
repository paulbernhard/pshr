module Pshr
  class Upload < ApplicationRecord
    belongs_to :uploadable, polymorphic: true

    
  end
end
