class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  
  has_many :microposts, dependent: :destroy

  before_save { |user| user.email = user.email.downcase }
  before_save { generate_token :auth_token }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    # This is a proto-feed
    Micropost.where("user_id = ?", id)
  end

private

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
