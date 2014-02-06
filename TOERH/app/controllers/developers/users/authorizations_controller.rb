class Developers::Users::AuthorizationsController < ApplicationController
	layout "developers"
	
	def show
		if !current_user.nil?
			redirect_to root_path
		end
	end

	def login
		user = User.find_by_email(params[:email])

		if user && user.authenticate(params[:password])
			session[:userid] = user.id
			redirect_to applications_path
		else
			@error = "Invalid E-mail and/or password."
			render :action => "show"
		end

	end

	def logout
		session[:userid] = nil
		flash[:notice] = "You have been logged out."
		redirect_to root_path
	end
	
end
