require 'Application'

# headers = env.select {|k,v| k.start_with? 'HTTP_'}
#    .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
 #  .collect {|pair| pair.join(": ") << "<br>"}
 #   .sort

class RateLimit
  def initialize(app)
    @app = app
  end

  def call(env)
    authValues = {}

    env['HTTP_AUTHORIZATION'].split(/[,]/).each do | authHeader |
      key, value = authHeader.split(/[=]/)
      authValues[key] = value
    end
    puts env['HTTP_AUTHORIZATION']
    apiKey = authValues["apiKey"]
    
    # If a api key was included
    if apiKey
      # Try to get the current limit from Redis
      count = REDIS.get(apiKey)

      # If no limit was found in redis
      if !count
        # Re authenticate
        ak = ApiKey.find_by_key(apiKey)
        application = Application.find_by_id((ak ? ak.application_id : 0))

        # Get limit for application
        if application && application.active
          count = limit = application.application_rate_limit.limit
          expire = 60 * 60 # 1 hour
          # Set current count
          REDIS.set(apiKey, count)
          REDIS.expire(apiKey, expire)

          # Set current limit
          REDIS.set("limit#{apiKey}", limit)
          REDIS.expire("limit#{apiKey}", expire)
        else
          return unauthorized_response
        end
      else
        limit = REDIS.get("limit#{apiKey}")
      end

      count = count.to_i
      limit = limit.to_i
      if count == 0
        limit_exceeded_response(count, apiKey, limit)
      else
        # Descrease count, add rate limit headers
        REDIS.decr(apiKey)
        status, headers, body = @app.call(env)
        [
          status,
          headers.merge(rate_limit_headers(count, apiKey, limit)),
          body
        ]

      end
    else
      unauthorized_response
    end
    
  end

  private

  def unauthorized_response
    [
      401,
      {},
      [{
        :error => "A valid Api key is required."
      }.to_json]
    ]
  end

  def limit_exceeded_response(count, apiKey, limit)
    [
      429,
      rate_limit_headers(count, apiKey, limit),
      [{
        :error => "Request limit exceeded."
      }.to_json]
    ]
  end

  def rate_limit_headers(count, apiKey, limit)
    ttl = REDIS.ttl(apiKey)
    time = Time.now.to_i
    time_till_reset = (time + ttl.to_i).to_s
    {
      "X-Rate-Limit-Limit" =>  limit.to_s,
      "X-Rate-Limit-Remaining" => (count - 1).to_s,
      "X-Rate-Limit-Reset" => time_till_reset
    }
  end

end