class ResourceType < ActiveRecord::Base
	include GuidGen
	
	has_many :resource

	validates :name, 
						:uniqueness => true,
						:presence => true,
						:length => {minimum: 2, maximum: 50}	

	validates :description, 
						:length => {minimum: 2, maximum: 200},
						:allow_blank => true

	def self.by_name(name)
    return all unless name.present?
  		where('name like ?', "%#{name}%",)
	end
end
