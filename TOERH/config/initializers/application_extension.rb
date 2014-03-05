module ApplicationExtension
  extend ActiveSupport::Concern

  included do
    belongs_to :application_rate_limit, class_name: 'ApplicationRateLimit'
  end
end

