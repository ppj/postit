class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  before_save :generate_slug

  validates :name, length: {minimum: 4}, uniqueness: true

  def to_param
    self.slug
  end

  private

  def generate_slug
    self.slug = self.name.gsub(/\s+/,'_').gsub(/\W/,'').gsub('_','-').gsub(/-+$/,'').gsub(/^-+/,'').gsub(/-+/,'-').downcase
  end

end
