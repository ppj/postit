class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments, dependent: :destroy
  has_many :post_categories
  has_many :categories, through: :post_categories

  has_many :votes, as: :voteable, dependent: :destroy

  validates :title, length: {minimum: 5}
  validates :url, presence: true, uniqueness: true
  validates :description, length: {minimum: 20}

  def vote_count
    up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

end
