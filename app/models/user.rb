class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 1, maximum: 20 }, format: /\A[a-zA-Z0-9_\.]+\z/

  attr_writer :login

  after_create do
    self.add_role :user if self.roles.blank?
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).find_by(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
    elsif conditions[:username].nil?
      find_by(conditions)
    else
      find_by(username: conditions[:username])
    end
  end
end
