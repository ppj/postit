class User < ActiveRecord::Base
  include Sluggable
  set_slug_column_to :username

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_secure_password validations: false

  validates :username, length: {minimum: 3}, uniqueness: true
  validates :password, on: :create, length: {minimum: 3}

  def admin?
    self.role == 'admin'
  end
end
