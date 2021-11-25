class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
end
