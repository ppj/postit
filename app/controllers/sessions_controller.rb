class SessionsController < ApplicationController

  def new

  end

  def create

    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'You have successfully logged in.'
      redirect_to root_path
    else
      flash.now[:error] = 'The username or password you entered is incorrect.'
      render :new
    end

  end

  def destroy
    if logged_in?
      session[:user_id] = nil
      flash[:notice] = 'You have logged out.'
    end
    redirect_to root_path
  end

end
