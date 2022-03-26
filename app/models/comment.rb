class Comment < ApplicationRecord
  # Association
  belongs_to :user
  belongs_to :post
  has_many :likes, as: :likeable

  #validation
  validates :text, presence: true
end
