class ApplicationController < ActionController::Base
  helper_method :current_user, :sign_in?

  private

  def sign_in?
    current_user.present?
  end

  def authenticate_user
    return if current_user

    redirect_to new_session_path
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
