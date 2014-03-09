class User < ActiveRecord::Base
	include GuidGen
	
	has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner, :dependent => :destroy

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
		self.user_role.name == 'admin'
	end

	def self.by_name(name)
	  return all unless name.present?
	 		where("firstname = ? OR lastname = ?", name, name)
	end
end
