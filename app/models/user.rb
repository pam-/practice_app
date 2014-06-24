require 'valid_email'

class User < ActiveRecord::Base
  has_many :experiences, dependent: :destroy
  before_save { self.email = email.downcase }
  before_create :create_remember_token #before_create in order to assign token to user
	validates :name, presence: true, length: { maximum: 8 }#, uniqueness: true
  validates :email, presence: true, :email => true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end 

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end 

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end 
end
