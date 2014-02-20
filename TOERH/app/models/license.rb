class License < ActiveRecord::Base
	include GuidGen
	include DbHelper

	has_many :resoruce

	validates :name, 
						:uniqueness => true,
						:presence => true,
						:length => {minimum: 2, maximum: 100}

	validates :description, 
						:length => {minimum: 10, maximum: 2000},
						:allow_blank => true

	validates :url, 
						:length => {minimum: 3, maximum: 200},
						:allow_blank => true

end
