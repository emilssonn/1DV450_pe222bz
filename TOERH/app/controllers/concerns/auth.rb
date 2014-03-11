module Auth
	extend ActiveSupport::Concern

	def current_user
    if doorkeeper_token
      @current_user ||= User.find(doorkeeper_token.resource_owner_id)
    end
	end

  def doorkeeper_unauthorized_render_options
    error = { 
      status: 401,
      message: "Login failed.",
      developerMessage: "Token invalid"  
    }
    respond_to do |format|
      format.json do
        { json: error }
      end
      format.xml do 
        { xml: error }
      end
    end
  end

   # Validate the api key sent with the request.
  def restrict_with_token
    @apiKey = request.headers['X-CLIENT-ID'] if request.headers['X-CLIENT-ID']
    if @apiKey
      @count = REDIS.get(@apiKey)

      if !@count
        # Api key was not found in redis
        # Re authenticate
        application = Doorkeeper::Application.find_by_uid(@apiKey)

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

end