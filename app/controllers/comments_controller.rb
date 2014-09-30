class CommentsController < ApplicationController
  def create
    # binding.pry

    @post    = Post.find(params[:post_id])
    @comment = @post.comments.new(params.require(:comment).permit(:body))
    @comment.creator = User.first # FIXME: Change once we have authentication

    if @comment.save
      flash[:notice] = "New comment added"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end

  end
end
