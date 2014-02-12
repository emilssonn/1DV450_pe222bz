class User < ActiveRecord::Base
	include GuidGen
	
	has_many :application
	belongs_to :user_role

	has_secure_password

	validates :firstname,
						:length => {minimum: 2, maximum: 40}

	validates :lastname,
						:length => {minimum: 2, maximum: 40}

	validates :email, 
						:uniqueness => true,
						:presence => true

	def is_admin
		self.user_role.id == 2
	end
end
