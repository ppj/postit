class CategoriesController < ApplicationController

  before_action :require_user, except: [:show]

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:name))

    if @category.save
      flash[:notice] = 'New category created.'
      redirect_to categories_path
    else
      render :new
    end
  end

  private


end

