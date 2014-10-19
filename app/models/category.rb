class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  include Sluggable
  before_save 'generate_slug!("name")'

  validates :name, length: {minimum: 4}, uniqueness: true

end
