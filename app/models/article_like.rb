class ArticleLike < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :article, optional: true
  validates_uniqueness_of :article_id, scope: :user_id
end
