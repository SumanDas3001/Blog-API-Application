class Post < ApplicationRecord
  attr_accessor :post_like_count

  # Association
  has_many :comments, dependent: :destroy
  belongs_to :user, optional: true
  has_many :likes, as: :likeable, dependent: :destroy
  # Declaration
  enum status: { unread: 0, read: 1 }

  # Validations
  validates :status, presence: true
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { in: 5..100 }
end
