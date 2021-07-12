class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  scope :list_followed_id, ->(user_id){where("follower_id = ?", user_id)}
end
