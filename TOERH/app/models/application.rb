class Application < ActiveRecord::Base
	has_one :api_key, :dependent => :destroy
	belongs_to :user
	belongs_to :application_rate_limit

	validates :name, 
						:uniqueness => true,
						:presence => true

end
