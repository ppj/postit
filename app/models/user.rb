class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_secure_password validations: false

  include Sluggable
  before_save 'generate_slug! "username" '

  validates :username, length: {minimum: 3}, uniqueness: true
  validates :password, on: :create, length: {minimum: 3}

  def admin?
    self.role == 'admin'
  end
end
