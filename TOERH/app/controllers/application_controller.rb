class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  helper_method :current_user

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

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

  def save_location
    session[:return_url] = request.original_url if request.get?
  end

  def redirect_back
    redirect_to (session[:return_url] || root_path)
    session[:return_url] = nil
  end

end
