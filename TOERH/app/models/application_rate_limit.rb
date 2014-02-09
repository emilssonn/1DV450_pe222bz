class ApplicationRateLimit < ActiveRecord::Base
	has_many :application

	def rate_limit_name_and_limit
		name << ", " << limit.to_s
	end
end
