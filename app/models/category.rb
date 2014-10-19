class Category < ActiveRecord::Base
  include Sluggable
  set_slug_column_to :name

  has_many :post_categories
  has_many :posts, through: :post_categories


  validates :name, length: {minimum: 4}, uniqueness: true

end
