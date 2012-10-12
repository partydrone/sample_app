class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  default_scope order: "created_at desc"

  validates :content, presence: true, length: { maximum: 140 }
end
