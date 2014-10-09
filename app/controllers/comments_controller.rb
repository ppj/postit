class CommentsController < ApplicationController

  before_action :set_post

  before_action :require_user

  def create

    @comment = @post.comments.new(params.require(:comment).permit(:body))
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "New comment added"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end

  end

  def vote
    @comment = Comment.find(params[:id])
    vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)

    if vote.valid?
      flash[:notice] = 'Your vote was cast.'
    else
      flash[:error]  = 'You can vote only once on this post.'
    end

    redirect_to :back

  end

  private

  def set_post
    @post    = Post.find(params[:post_id])
  end

end
