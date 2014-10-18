module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

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