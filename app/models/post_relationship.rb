class PostRelationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "Experience"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
