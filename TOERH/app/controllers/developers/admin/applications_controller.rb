class Developers::Admin::ApplicationsController < ApplicationController
	before_action :require_admin
	layout "developers"

	def index
		@applications = Application.all
	end

	def edit
		@application = Application.find_by_id(params[:id])
	end

	def update
		@application = Application.find_by_id(params[:id])

		if @application.update(application_params)
			redirect_to admin_applications_path(@application)
		else
			render 'edit'
		end
	end

	private
	
	def application_params
		params.require(:application).permit(:name, :active, :application_rate_limit_id)
	end
end
