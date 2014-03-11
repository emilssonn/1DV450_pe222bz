require "omniauth/strategies/toerh"

ENV["OAUTH_ID"] = 'dbfb4187d7209f31e08d7d0552235778ebca62312670919209d85dca1ecbf727'
ENV["OAUTH_SECRET"] = 'f8637c2428d1e8efa7db6dfd8508d496e3d928c1052fed43eab0bc49d0b908b7'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :toerh, ENV["OAUTH_ID"], ENV["OAUTH_SECRET"]
end