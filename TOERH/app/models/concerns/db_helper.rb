module DbHelper
	extend ActiveSupport::Concern
	
	included do
		def self.by_name(name)
	    return all unless name.present?
	  		where("#{self.to_s.downcase.pluralize}.name like ?", "%#{name}%",)
		end
	end

end