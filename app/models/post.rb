class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments, dependent: :destroy
  has_many :post_categories
  has_many :categories, through: :post_categories

  has_many :votes, as: :voteable, dependent: :destroy

  before_save :generate_slug!

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

  def to_param
    self.slug
  end

  private

  def generate_slug!
    the_slug = to_slug(self.title)

    count = 1
    record = Post.find_by slug: the_slug
    while record and record != self
      the_slug = make_unique(the_slug, count)
      record = Post.find_by slug: the_slug
      count += 1
    end

    self.slug = the_slug
  end

  def to_slug(str)                # str=" @#$@ My First @#2@%#@ Post!!
    str = str.strip               #  --> @#$@ My First @#2@%#@ Post!!
    str.gsub!(/[^A-Za-z0-9]/,'-') #  --> -----My-First---2-----Post--
    str.gsub!(/-+/,'-')           #  --> -My-First-2-Post-
    str.gsub!(/^-+/,'')           #  --> My-First-2-Post-
    str.gsub!(/-+$/,'')           #  --> My-First-2-Post
    str.downcase                  #  --> my-first-2-post
  end

  def make_unique(the_slug, count)
    arr = the_slug.split('-')
    if arr.last.to_i == 0
      the_slug = the_slug + '-' + count.to_s
    else
      the_slug = arr[0...-1].join('-') + '-' + count.to_s
    end
    the_slug
  end

end
