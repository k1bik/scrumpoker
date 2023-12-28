class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def authenticate_user
    return if current_user

    redirect_to new_session_path
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
