class User < ActiveRecord::Base
	has_many :application

	has_secure_password

	validates :firstname,
						:length => {minimum: 2, maximum: 40}

	validates :lastname,
						:length => {minimum: 2, maximum: 40}

	validates :email, 
						:uniqueness => {:message => "is already in use."},
						:presence => true
end
