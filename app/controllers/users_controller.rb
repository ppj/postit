class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]

  before_action :require_user, only: [:edit]

  before_action :match_user, only: [:edit]

  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You are registered."
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update

    if @user.update(user_params)
      flash[:notice] = "Profile updated."
      redirect_to user_path(@user)
    else
      render :edit
    end

  end

  def show
  end


  private

  def user_params
    params.require(:user).permit(:username, :password, :timezone)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def match_user
    unless current_user == @user
      flash[:error] = "You cannot edit this profile!"
      redirect_to user_path(@user)
    end
  end



end
