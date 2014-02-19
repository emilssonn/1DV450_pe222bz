class Tag < ActiveRecord::Base
	include GuidGen
	include DbHelper

	validates :name, 
						:uniqueness => true,
						:presence => true,
						:length => {minimum: 2, maximum: 20}

end
