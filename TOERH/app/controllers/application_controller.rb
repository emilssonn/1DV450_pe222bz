class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper

  private

  def require_login
  	if current_user.nil? then
      save_location
  		redirect_to login_path subdomain: false
  	end
  end

  def require_admin
    if !current_user.is_admin then
      redirect_to root_path
    end
  end

  def save_location loc
    session[:return_url] = loc || request.original_url if request.get?
  end

  def redirect_back
    redirect_to (session[:return_url] || root_path)
    session[:return_url] = nil
  end

end
