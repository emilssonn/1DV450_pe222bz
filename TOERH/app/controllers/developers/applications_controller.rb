class Developers::ApplicationsController < ApplicationController
	before_action :require_login
	layout "developers"

	def index
		@applications = current_user.oauth_applications
	end

	def show
		@application = current_user.oauth_applications.find(params[:id])
	end

	def new
		@application = Doorkeeper::Application.new
	end

	def create
		@application = Doorkeeper::Application.new(application_params)
		@application.owner = current_user
		@application.application_rate_limit = ApplicationRateLimit.order(limit: :asc).first

		if @application.save
			redirect_to application_path(@application)
		else
			render :new
		end
	end

	def edit
		@application = current_user.oauth_applications.find(params[:id])
	end

	def update
		@application = current_user.oauth_applications.find(params[:id])

		if @application.update(application_params)
			redirect_to application_path(@application)
		else
			render :edit
		end
	end

	def destroy
		@application = current_user.oauth_applications.find(params[:id])

		if @application.delete
			flash[:notice] = 'The application "' + @application.name + '"" has been deleted.'
			redirect_to applications_path
		else
			render :show, :alert => 'Error deleteing application.'
		end
	end

	private

	def application_params
		params.require(:application).permit(:name, :redirect_uri)
	end
end
