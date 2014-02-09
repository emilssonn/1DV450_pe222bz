class Developers::ApplicationsController < ApplicationController
	before_action :require_login
	layout "developers"

	def index
		@applications = current_user.application
	end

	def show
		@application = current_user.application.find(params[:id])
	end

	def new
		@application = Application.new
	end

	def create
		@application = Application.new(application_params)
		@application.user = current_user
		@application.api_key = ApiKey.new

		if @application.save
			redirect_to application_path(@application)
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
			redirect_to application_path(@application)
		else
			render 'edit'
		end
	end

	def destroy
		@application = current_user.application.find(params[:id])

		if @application.delete
			flash[:notice] = 'The application "' + @application.name + '"" has been deleted.'
			redirect_to applications_path
		else
			render 'show', :alert => 'Error deleteing application.'
		end
	end

	private

	def application_params
		params.require(:application).permit(:name)
	end
end
