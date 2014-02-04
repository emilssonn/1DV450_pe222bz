class ApiKey < ActiveRecord::Base
	belongs_to :application

	before_create :generateApiKey

	private

		# Generate a random api key, check for uniqueness, regenerate if it already exists
		def generateApiKey
			begin
				self.key = SecureRandom.hex()
			end while self.class.exists?(key: key)
		end

end
