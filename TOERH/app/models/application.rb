class Application < ActiveRecord::Base
	has_one :api_key
	belongs_to :user

	validates :name, 
						:uniqueness => {:message => "is already in use."},
						:presence => true
end
