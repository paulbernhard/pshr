class Post < ApplicationRecord
  has_many :uploads, as: :uploadable
  has_many :custom_uploads, as: :uploadable
end
