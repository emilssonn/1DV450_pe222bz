class Tag < ActiveRecord::Base
	include GuidGen
	
	validates :name, 
						:uniqueness => true,
						:presence => true,
						:length => {minimum: 2, maximum: 20}

	def self.by_name(name)
    return all unless name.present?
  		where('name like ?', "%#{name}%",)
	end

end
