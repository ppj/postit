class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments, dependent: :destroy
  has_many :post_categories
  has_many :categories, through: :post_categories

  include Voteable
  include Sluggable
  before_save 'generate_slug! "title"'

  validates :title, length: {minimum: 5}
  validates :url, presence: true, uniqueness: true
  validates :description, length: {minimum: 20}
end
