class Api::V1::ApiBaseController < ActionController::Base
  rescue_from Exception, :with => :error_response

  before_action :require_token
  before_action :rate_limit
  before_action :limit_offset, :only => [:index]

	private

  helper_method :current_user

  def limit_offset
    @limit = params[:limit].to_i > 0 && params[:limit].to_i < 30 ? params[:limit].to_i : 30 rescue 30
    @offset = params[:offset].to_i >= 0 ? params[:offset].to_i : 0 rescue 0
  end

  def current_user
    if user = authenticate_with_http_basic { |u, p | User.find_by_email(u).authenticate(p) rescue false}
      @current_user = user
    end
  end

  def require_login
    if current_user.nil?
      error = { 
        status: 401,
        message: "Login failed.",
        developerMessage: "The email and/or password provided is invalid."  
      }
      respond_to do |format|
        format.json { render :json => error.to_json, :status => :unauthorized }
        format.xml { render :xml => error.to_xml, :status => :unauthorized }
      end
    end
  end

  def rate_limit
    if current_user.nil?
      rate_limit_by_api_key
    else
      rate_limit_by_user
    end
  end

  def rate_limit_by_user
    limit = 5000
    count = REDIS.get(@current_user.id)
    if !count
      REDIS.set(@current_user.id, limit)
      REDIS.expire(@current_user.id, 60 * 60)
    end

    if count == 0
      limit_exceeded_response(count, @current_user.id, limit)
    else
      # Descrease count, add rate limit headers
      REDIS.decr(@current_user.id)
      rate_limit_headers(count, @current_user.id, limit)
    end
  end

  def rate_limit_by_api_key
    if @count == 0
      limit_exceeded_response(@count, @apiKey, @limit)
    else
      # Descrease count, add rate limit headers
      REDIS.decr(@apiKey)
      rate_limit_headers(@count, @apiKey, @limit)
    end
  end

  def require_token
    authValues = {}
    env['HTTP_AUTHORIZATION'].split(/[,]/).collect{|x| x.strip}.each do | authHeader |
      key, value = authHeader.split(/[=]/)
      authValues[key] = value
    end if env['HTTP_AUTHORIZATION']
    @apiKey = authValues["apiKey"] if authValues["apiKey"]

    if @apiKey
      @count = REDIS.get(@apiKey)

      if !@count
        # Re authenticate
        ak = ApiKey.find_by_key(@apiKey)
        application = Application.find_by_id((ak ? ak.application_id : 0))

        # Get limit for application
        if application && application.active
          @count = @limit = application.application_rate_limit.limit
          expire = 60 * 60 # 1 hour
          # Set current count
          REDIS.set(@apiKey, @count)
          REDIS.expire(@apiKey, expire)
            # Set current limit
          REDIS.set("limit#{@apiKey}", @limit)
          REDIS.expire("limit#{@apiKey}", expire)
        else
          return unauthorized_response
        end
      else
        @limit = REDIS.get("limit#{@apiKey}")
      end

      if @count == 0
        limit_exceeded_response(@count, apiKey, @limit)
      else
        rate_limit_headers(@count, @apiKey, @limit)
      end
    else
      unauthorized_response
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

  def unauthorized_response
    error = {
      :status => 401,
      :message => "A valid Api key is required.",
      :developerMessage => ""
    }
    respond_to do |format|
      format.json { render :json => error.to_json, :status => :unauthorized }
      format.xml { render :xml => error.to_xml, :status => :unauthorized }
    end
  end

  def limit_exceeded_response(count, key, limit)
    rate_limit_headers(count, key, limit)
    error = {
      :status => 429,
      :message => "Request limit exceeded.",
      :developerMessage => ""
    }
    respond_to do |format|
      format.json { render :json => error.to_json, :status => 429 }
      format.xml { render :xml => error.to_xml, :status => 429 }
    end
  end


  def rate_limit_headers(count, key, limit)
    ttl = REDIS.ttl(key)
    time = Time.now.to_i
    time_till_reset = time + ttl.to_i

    response.headers["X-Rate-Limit-Limit"] = limit.to_s
    response.headers["X-Rate-Limit-Remaining"] = (count.to_i - 1).to_s
    response.headers["X-Rate-Limit-Reset"] = time_till_reset.to_s
  end

end
