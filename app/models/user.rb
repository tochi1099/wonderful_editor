# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
end
