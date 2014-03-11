require 'omniauth'
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Toerh < OmniAuth::Strategies::OAuth2
      option :name, :toerh

      option :client_options, {
        :site => "http://lvh.me:4000",
        :authorize_path => "http://lvh.me:4000/oauth/authorize"
      }

      uid do
        raw_info["instance"]["id"]
      end

      info do
        {
          :email => raw_info["instance"]["email"],
          :firstname => raw_info["instance"]["firstname"],
          :lastname => raw_info["instance"]["lastname"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get('http://api.lvh.me:4000/v1/users/me').parsed
      end
    end
  end
end