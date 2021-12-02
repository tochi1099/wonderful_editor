class Comment < ApplicationRecord
  validates :body, presence: true
  # validates :article_id, uniqueness: { scope: :user_id }
  belongs_to :user, optional: true
  belongs_to :article, optional: true
end
