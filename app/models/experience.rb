class Experience < ActiveRecord::Base
	belongs_to :user 
	default_scope -> { order('created_at DESC') } #descending order from SQL
	validates :user_id, presence: true #makes sure user_id is never nil
	validates :content, presence: true
	validates :content, presence: true
	validates :title, presence: true
	
end
