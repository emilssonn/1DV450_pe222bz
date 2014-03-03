require "doorkeeper"

module ApplicationExtension
  extend ActiveSupport::Concern

  included do
    belongs_to :application_rate_limit
  end
end

Doorkeeper::Application.send :include, ApplicationExtension