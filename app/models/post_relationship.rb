class PostRelationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "Experience"
  validates :follower, presence: true
  validates :followed, presence: true
end
