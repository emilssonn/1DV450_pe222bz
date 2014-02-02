class Application < ActiveRecord::Base
	has_one :api_key

	validates :contact_mail, 
						:uniqueness => {:message => "This email is already in use."},
						:presence => {:message => "A email address is required."}
end
