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


	# DB helpers
	 
	def self.by_name(name)
    return scoped unless name.present?
  		where('name like ?', name)
	end

	def self.by_resource_type_ids(resource_type_ids)
	  return scoped unless resource_type_ids.present?
		  ids = resource_type_ids.split(',').collect{|x| x.strip}
		  ### ----- join to get real ids
		  where(resource_type_id: ids)
	end


end
