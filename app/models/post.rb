class Post < ActiveRecord::Base
	belongs_to :user

  has_many :categorizations
  has_many :categories, through: :categorizations
  has_many :post_relationships, foreign_key: "followed_id"
  has_many :followers, through: :post_relationships
  has_many :comments

  accepts_nested_attributes_for :categorizations

	default_scope -> { order('created_at DESC') } #descending order from SQL
	validates :user_id, presence: true #makes sure user_id is never nil
	validates :content, presence: true
	validates :title, presence: true

  def categorize_into!(category)
    categorizations.create!(category_id: category.id)
  end 

  def categorized_into?(category)
    categorizations.find_by(category_id: category.id)
  end 


end