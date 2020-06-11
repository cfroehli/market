# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 1, maximum: 20 }, format: /\A[a-zA-Z0-9_.]+\z/

  has_many :orders

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :comments, dependent: :destroy

  has_many :posts, dependent: :destroy

  after_create { add_role(:user) }

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).find_by(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
  end
end
