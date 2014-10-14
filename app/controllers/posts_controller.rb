class PostsController < ApplicationController

  before_action :set_post,     except: [:index, :new, :create]
  before_action :require_user, except: [:index, :show]
  before_action :match_user,   only:   [:edit]


  def index
    @posts = Post.all.sort_by{|x| x.updated_at}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create

    @post = Post.new(post_params)
    @post.creator = current_user

    category_index = create_new_category

    if category_index
      flash[:notice] = "Category & Post created successfully!"
      category_check_passed = true
    elsif @category
      category_check_passed = @category.errors.empty?
    else
      category_check_passed = true
    end

    if @post.save && category_check_passed
      @post.categories << @category if category_index
      flash[:notice] ||= "Post created successfully!"
      redirect_to posts_path
    else
      @new_category = params[:new_category]
      render :new
    end

  end

  def edit
  end

  def update

    category_index = create_new_category

    if category_index
      flash[:notice] = "Category & Post created successfully!"
      category_check_passed = true
    elsif @category
      category_check_passed = @category.errors.empty?
    else
      category_check_passed = true
    end

    if @post.update(post_params) && category_check_passed
      @post.categories << @category if category_index
      flash[:notice] ||= "Post updated successfully!"
      redirect_to post_path(@post)
    else
      @new_category = params[:new_category]
      render :edit
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
    @post = Post.find(params[:id])
  end

  def match_user
    unless current_user == @post.creator
      flash[:error] = "You cannot edit this post!"
      redirect_to post_path(@post)
    end
  end

  def create_new_category

    if params[:new_category].strip.empty?
      false
    else
      category_names = Category.all.map(&:name)
      index = category_names.index(params[:new_category])
      if index
        @category = Category.find_by(name: category_names[index])
        @category.id
      else
        @category = Category.new(name: params[:new_category])
        if @category.save
          @category.id
        else
          false
        end
      end
    end

  end

end
