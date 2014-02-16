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
    return all unless name.present?
  		where('resources.name like ?', "%#{name}%",)
	end

	def self.by_resource_type_ids(resource_type_ids)
	  return all unless resource_type_ids.present?
		  ids = resource_type_ids.split(',').collect{|x| x.strip}
		  where(resource_type_id: ResourceType.select(:id).where(:public_id => ids))
	end

	def self.by_license_ids(license_ids)
	  return all unless license_ids.present?
		  ids = license_ids.split(',').collect{|x| x.strip}
		  where(license_id: License.select(:id).where(:public_id => ids))
	end

	def self.by_tags(tags)
	  return all unless tags.present?
		  tags = tags.split(',').collect{|x| x.strip}
		  joins(:tags).where(tags: {name: tags})
	end

	def self.by_user_ids(user_ids)
	  return all unless user_ids.present?
		  ids = user_ids.split(',').collect{|x| x.strip}
		  where(user_id: User.select(:id).where(:public_id => ids))
	end


end
