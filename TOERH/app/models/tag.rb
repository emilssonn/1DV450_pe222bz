class Tag < ActiveRecord::Base
	include GuidGen
	
	validates :name, 
						:uniqueness => true,
						:presence => true,
						:length => {minimum: 2, maximum: 20}

end
