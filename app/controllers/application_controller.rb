class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter :temporary_notice
  
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def require_login!
    unless current_user
      redirect_to root_path, :alert => "You must be logged in to access this."
      return false
    end
  end

  def temporary_notice
    flash.now[:notice] = "Note: The BluePass doesn't begin until August 22nd. We'll begin tracking flights then! "
  end

end
