class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, 
  :jwt_authenticatable,:registerable, jwt_revocation_strategy: self

  #Validations
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true  

  # Association
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
end
