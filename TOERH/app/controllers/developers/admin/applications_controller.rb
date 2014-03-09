class Developers::Admin::ApplicationsController < ApplicationController
	before_action :require_login, :require_admin
	layout "developers"

	def index
		@applications = Doorkeeper::Application.all
	end

	def edit
		@application = Doorkeeper::Application.find_by_id(params[:id])
	end

	def update
		@application = Doorkeeper::Application.find_by_id(params[:id])

		if @application.update(application_params)
			if !@application.active
				REDIS.del(@application.uid)
			end
			redirect_to admin_applications_path(@application)
		else
			render 'edit'
		end
	end

	private
	
	def application_params
		params.require(:application).permit(:name, :redirect_uri, :active, :application_rate_limit_id)
	end
end
