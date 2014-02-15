#
# All calls to the Api requires a valid Api key, this is checked in app/middleware/rate_limit.rb
#
class Api::V1::ApiBaseController < ActionController::Base
	#rescue_from StandardError, :with => :error_render_method

	private

  def error_render_method
    error = { 
			status: 500,
			message: "Internal server error.",
			developerMessage: "An unexpected error occured on the server. This was not caused by any faulty request parameters."  
		}
		respond_to do |format|
			format.json { render :json => error.to_json, :status => :internal_server_error }
			format.xml { render :xml => error.to_xml, :status => :internal_server_error }
		end
    
  end

  helper_method :current_user

  def current_user
  	@current_user ||= User.find(session[:userid]) if session[:userid]
  end

  def require_login
  	if current_user.nil? then
  		
  	end
  end

  def not_found_response_base(error)
    respond_to do |format|
      format.json { render :json => error.to_json, :status => :not_found }
      format.xml { render :xml => error.to_xml, :status => :not_found }
    end
  end
end
