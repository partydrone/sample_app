class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :content, presence: true, length: { maximum: 140 }

  default_scope order: "created_at desc"

  def self.from_users_followed_by(user)
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where "user_id IN (#{following_ids}) OR user_id = :user_id", user_id: user
  end
end
