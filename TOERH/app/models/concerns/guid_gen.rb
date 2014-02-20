module GuidGen
	extend ActiveSupport::Concern
	
	included do
		before_create :generate_guid
	end

	private

	def generate_guid
		begin
			self.public_id = SecureRandom.uuid()
		end while self.class.exists?(public_id: public_id)
	end

end