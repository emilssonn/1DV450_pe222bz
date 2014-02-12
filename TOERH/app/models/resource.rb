class Resource < ActiveRecord::Base
	include GuidGen
	
	has_and_belongs_to_many :tags
	belongs_to :resource_type
	belongs_to :user
	belongs_to :license

	validates :name, 
						:uniqueness => true,
						:presence => true,
						:length => {minimum: 5, maximum: 30}

	validates :description, 
						:presence => true,
						:length => {minimum: 10, maximum: 350}

	validates :url, 
						:uniqueness => true,
						:presence => true,
						:length => {minimum: 5, maximum: 200}
end
