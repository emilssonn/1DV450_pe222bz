class Developers::Admin::AdminsController < ApplicationController
	before_action :require_login, :require_admin
	layout "developers"

	def index
		
	end


end
