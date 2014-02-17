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

  def not_found_response_base(error)
    respond_to do |format|
      format.json { render :json => error.to_json, :status => :not_found }
      format.xml { render :xml => error.to_xml, :status => :not_found }
    end
  end

  helper_method :current_user

  def current_user
    if user = authenticate_with_http_basic { |u, p| User.find_by_email(u).authenticate(p) }
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
      limit_exceeded_response(@count, params[:api_key], @limit)
    else
      # Descrease count, add rate limit headers
      REDIS.decr(params[:api_key])
      rate_limit_headers(@count, params[:api_key], @limit)
    end
  end

  def require_token
    
    if params[:api_key]
      @count = REDIS.get(params[:api_key])

      if !@count
        # Re authenticate
        ak = ApiKey.find_by_key(params[:api_key])
        application = Application.find_by_id((ak ? ak.application_id : 0))

        # Get limit for application
        if application && application.active
          @count = @limit = application.application_rate_limit.limit
          expire = 60 * 60 # 1 hour
          # Set current count
          REDIS.set(params[:api_key], @count)
          REDIS.expire(params[:api_key], expire)
            # Set current limit
          REDIS.set("limit#{params[:api_key]}", @limit)
          REDIS.expire("limit#{params[:api_key]}", expire)
        else
          return unauthorized_response
        end
      else
        @limit = REDIS.get("limit#{params[:api_key]}")
      end

      if @count == 0
        limit_exceeded_response(@count, apiKey, @limit)
      else
        rate_limit_headers(@count, params[:api_key], @limit)
      end
    else
      unauthorized_response
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
