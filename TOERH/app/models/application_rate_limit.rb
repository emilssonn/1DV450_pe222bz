class ApplicationRateLimit < ActiveRecord::Base
	has_many :oauth_applications

	def rate_limit_name_and_limit
		name << ", " << limit.to_s
	end
end
