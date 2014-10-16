class CommentsController < ApplicationController

  before_action :set_post, except: [:vote]

  before_action :set_comment, except: [:create]

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
    @vote    = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)
    respond_to do |format|
      format.html {
        if @vote.valid?
          flash[:notice] = 'Your vote was cast.'
        else
          flash[:error]  = 'You can vote only once on this comment.'
        end
        redirect_to :back
      }
      format.js # by default renders the vote.js.erb template in the comments folder
    end
  end

  def vote_destroy
    @vote = Vote.find_by(creator: current_user, voteable: @comment)
    @vote.destroy if @vote

    respond_to do |format|
      format.html {
        flash[:notice] = 'Your vote on that comment was cancelled'
        redirect_to :back
      }
      format.js { render 'vote' }
    end

  end

  private

  def set_post
    @post    = Post.find_by(slug: params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

end
