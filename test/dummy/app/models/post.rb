class Post < ApplicationRecord
  has_many :uploads, as: :uploadable
end
