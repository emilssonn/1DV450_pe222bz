#
# This module is dependant on the Auth module. The Auth module must be included before.
#
module RateLimit
	extend ActiveSupport::Concern
	
	included do
		before_action :rate_limit
	end

  # Check what rate limiting strategy to use
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
      count = limit
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