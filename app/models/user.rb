class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_secure_password validations: false

  before_save :generate_slug!

  validates :username, length: {minimum: 3}, uniqueness: true
  validates :password, on: :create, length: {minimum: 3}

  def admin?
    self.role == 'admin'
  end

  def to_param
    self.slug
  end

  private

  def generate_slug!
    the_slug = to_slug(self.username)

    count = 1
    record = User.find_by slug: the_slug
    while record and record != self
      the_slug = make_unique(the_slug, count)
      record = User.find_by slug: the_slug
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
