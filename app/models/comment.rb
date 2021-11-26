class Comment < ApplicationRecord
  validates :body, presence: true
  belongs_to :user, optional: true
  belongs_to :article, optional: true
end
