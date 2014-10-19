module Sluggable
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_column
    before_save :generate_slug!
  end

  module ClassMethods
    def set_slug_column_to(column)
      self.slug_column = column
    end
  end

  def to_param
    self.slug
  end

  private

  def generate_slug!

    the_slug = to_slug(self.send(self.class.slug_column))
    model = self.class.to_s

    count = 1
    record = self.class.find_by slug: the_slug
    while record and record != self
      the_slug = make_unique(the_slug, count)
      record = self.class.find_by slug: the_slug
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