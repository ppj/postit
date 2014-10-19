class Post < ActiveRecord::Base
  include Voteable
  include Sluggable
  set_slug_column_to :title

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments, dependent: :destroy
  has_many :post_categories
  has_many :categories, through: :post_categories


  validates :title, length: {minimum: 5}
  validates :url, presence: true, uniqueness: true
  validates :description, length: {minimum: 20}
end
