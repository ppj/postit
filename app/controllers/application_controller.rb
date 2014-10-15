class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:error] = "You need to log in before trying that!"
      redirect_to root_path
    end
  end

  def require_admin
    unless logged_in? and current_user.admin?
      flash[:error] = "You need admin access to do that!"
      redirect_to root_path
    end
  end

end
