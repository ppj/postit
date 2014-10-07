class CommentsController < ApplicationController

  before_action :require_user

  def create

    @post    = Post.find(params[:post_id])
    @comment = @post.comments.new(params.require(:comment).permit(:body))
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "New comment added"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end

  end
end
