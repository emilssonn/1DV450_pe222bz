module GuidGen
	extend ActiveSupport::Concern
	
	included do
		before_create :generate_guid
	end

	private

	def generate_guid
		self.public_id = SecureRandom.uuid()
	end

end