class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  def current_path
    respond_with(Rails.root.to_json)
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    unless current_user
      redirect_to log_in_url
    return false
    end
  end

end
