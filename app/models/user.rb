require 'valid_email'

class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy 
  has_many :post_relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_posts, through: :post_relationships, source: :followed

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships #looks through Relationship model so no need to specifify source. Rails looks for follower_id

  has_many :comments  

  before_save { self.email = email.downcase }
  before_create :create_remember_token #before_create in order to assign token to user
	validates :name, presence: true , length: { maximum: 50 } #, uniqueness: true
  validates :email, presence: true, :email => true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end 

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end 

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def following_post?(post)
    post_relationships.find_by(followed_id: post.id)
  end

  def follow_post!(post)
    post_relationships.create!(followed_id: post.id)
  end

  def unfollow_post!(post)
    post_relationships.find_by(followed_id: post.id).destroy
  end

  def assign_to!(category)
    categorizations.build(category_id: category.id)
  end

  def assigned?(category)
    categorizations.find_by(category_id: category.id)
  end
  
  def unassign_from!(category)
    categorizations.build(category_id: category.id).destroy
  end

  private

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end 
end
