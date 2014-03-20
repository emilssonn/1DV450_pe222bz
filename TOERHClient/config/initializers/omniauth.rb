require "omniauth/strategies/toerh"

ENV["OAUTH_ID"] = 'YOUR API KEY'
ENV["OAUTH_SECRET"] = 'YOUR API SECRET'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :toerh, ENV["OAUTH_ID"], ENV["OAUTH_SECRET"]
end