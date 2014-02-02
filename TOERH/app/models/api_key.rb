class ApiKey < ActiveRecord::Base
	belongs_to :application

	before_create :generateAuthKey

	private

		# Generate a random auth key, check for uniqueness, regenerate if it already exists
		def generateAuthKey
			begin
				self.auth_key = SecureRandom.hex()
			end while self.class.exists?(auth_key: auth_key)
		end

end
