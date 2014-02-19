class ResourceType < ActiveRecord::Base
	include GuidGen
	include DbHelper

	has_many :resource

	validates :name, 
						:uniqueness => true,
						:presence => true,
						:length => {minimum: 2, maximum: 50}	

	validates :description, 
						:length => {minimum: 2, maximum: 500},
						:allow_blank => true

end
