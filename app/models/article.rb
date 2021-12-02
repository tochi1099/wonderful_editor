class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
end
