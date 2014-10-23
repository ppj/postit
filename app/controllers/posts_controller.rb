class PostsController < ApplicationController

  before_action :set_post,     except: [:index, :new, :create]
  before_action :require_user, except: [:index, :show]
  before_action :require_creator_or_admin, only:   [:edit, :update]

  def index
    @posts = Post.all.sort_by{|x| x.updated_at}.reverse
    respond_to do |format|
      format.html
      format.json {render json: @posts}
      format.xml  {render xml:  @posts}
    end
  end

  def show
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.json {render json: @post}
      format.xml  {render xml:  @post}
    end
  end

  def new
    @post = Post.new
  end

  def create

    @post = Post.new(post_params)
    @post.creator = current_user

    @category = create_new_category

    flash[:notice] = ''
    if @category and @category.new_record?
      if @category.save
        flash[:notice] = "Category created successfully! "
      else
        flash[:error] = "Category not created: #{@category.errors.full_messages.join('; ')}"
      end
    end

    if @post.valid?
      @post.save
      @post.categories << @category if @category and @category.valid?
      flash[:notice] << "Post created successfully!"
      redirect_to posts_path
    else
      flash[:error] = nil
      flash[:notice] = flash[:notice].empty? ? nil : flash[:notice]
      render :new
    end

  end

  def edit
  end

  def update

    @category = create_new_category

    flash[:notice] = ''
    if @category and @category.new_record?
      if @category.save
        flash[:notice] = "Category created successfully! "
      else
        flash[:error] = "Category not created: #{@category.errors.full_messages.join('; ')}"
      end
    end

    if @post.update(post_params)
      @post.categories << @category if @category and @category.valid?
      flash[:notice] << "Post updated successfully!"
      redirect_to posts_path
    else
      flash[:error] = nil
      flash[:notice] = flash[:notice].empty? ? nil : flash[:notice]
      render :new
    end

  end

  def vote
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @post)

    respond_to do |format|
      format.html {
        if @vote.valid?
          flash[:notice] = 'Your vote was cast.'
        else
          flash[:error]  = 'You can vote only once on this post.'
        end
        redirect_to :back
      }
      format.js # by default renders the vote.js.erb template in the views/posts folder
    end

  end

  def vote_destroy
    @vote = Vote.find_by(creator: current_user, voteable: @post)
    @vote.destroy if @vote

    respond_to do |format|
      format.html {
        flash[:notice] = 'Your vote on that post was cancelled'
        redirect_to :back
      }
      format.js { render 'vote' }
    end

  end


  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def set_post
    @post = Post.find_by(slug: params[:id])
  end

  def require_creator_or_admin
    access_denied "You cannot edit this post!" unless logged_in? and (current_user == @post.creator or current_user.admin?)
  end

  def create_new_category

    if !params[:new_category] or params[:new_category].strip.empty?
      false
    else
      category_names = Category.all.map(&:name)
      index = category_names.index(params[:new_category])
      if index
        category = Category.find_by(name: category_names[index])
      else
        category = Category.new(name: params[:new_category])
      end
    end

  end

end
