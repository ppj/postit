class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_secure_password validations: false

  before_save :generate_slug

  validates :username, length: {minimum: 3}, uniqueness: true
  validates :password, on: :create, length: {minimum: 3}

  def admin?
    self.role == 'admin'
  end

  def to_param
    self.slug
  end

  private

  def generate_slug
    self.slug = self.username.gsub(/\s+/,'_').gsub(/\W/,'').gsub(/_+/,'_').downcase
  end

end
