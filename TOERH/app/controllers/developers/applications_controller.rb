class Developers::ApplicationsController < ApplicationController
	before_action :require_login
	layout "developers"

	def index
		@applications = current_user.application
	end

	def new
		@application = Application.new
	end

	def create
		@application = Application.new(application_params)
		@application.user = current_user
		@application.api_key = ApiKey.new

		if @application.save
			redirect_to applications_path
		else
			render :action => 'new'
		end
	end

	def edit
		@application = current_user.application.find(params[:id])
	end

	def update
		@application = current_user.application.find(params[:id])

		if @application.update(application_params)
			redirect_to applications_path
		else
			render 'edit'
		end
	end

	def application_params
		params.require(:application).permit(:name)
	end
end
