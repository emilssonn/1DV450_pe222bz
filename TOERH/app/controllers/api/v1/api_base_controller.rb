class Api::V1::ApiBaseController < ActionController::Base
  include Auth
  include RateLimit

  rescue_from Exception, :with => :error_response
  before_action :restrict_with_token
  before_action :rate_limit
  before_action :limit_offset, :only => [:index]

	private

  helper_method :current_user

  # Get the limit and offset from url
  def limit_offset
    @limit = params[:limit].to_i > 0 && params[:limit].to_i < 30 ? params[:limit].to_i : 30 rescue 30
    @offset = params[:offset].to_i >= 0 ? params[:offset].to_i : 0 rescue 0
  end

  def require_admin
    if !current_user.is_admin then
      head :not_found
    end
  end

  def error_response
    error = { 
      status: 500,
      message: "Internal Server Error",
      developerMessage: "An unexpected error occured on the server."  
    }
    respond_to do |format|
      format.json { render :json => error.to_json, :status => :internal_server_error }
      format.xml { render :xml => error.to_xml, :status => :internal_server_error }
    end 
  end

  def not_found_response_base(error)
    respond_to do |format|
      format.json { render :json => error.to_json, :status => :not_found }
      format.xml { render :xml => error.to_xml, :status => :not_found }
    end
  end

  def invalid_response(obj)
    error = { 
      status: 400,
      message: "Bad Request",
      developerMessage: "One or more fields posted were invalid. See errors object for more info.",
      errors: obj.errors
    }
    respond_to do |format|
      format.json { render :json => error.to_json, :status => :bad_request }
      format.xml { render :xml => error.to_xml, :status => :bad_request }
    end
  end

end
