class License < ActiveRecord::Base
	include GuidGen
	
	has_many :resoruce

	validates :name, 
						:uniqueness => true,
						:presence => true,
						:length => {minimum: 2, maximum: 100}

	validates :description, 
						:length => {minimum: 10, maximum: 250},
						:allow_blank => true

	validates :url, 
						:length => {minimum: 5, maximum: 200},
						:allow_blank => true

	def self.by_name(name)
    return all unless name.present?
  		where('name like ?', "%#{name}%",)
	end
end
