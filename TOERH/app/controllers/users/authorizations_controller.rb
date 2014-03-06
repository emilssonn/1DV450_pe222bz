class Users::AuthorizationsController < ApplicationController
	layout "developers"
	
	def show
		if !current_user.nil?
			redirect_to root_path
		end
		save_location params[:return_to] if params[:return_to]
	end

	def login
		user = User.find_by_email(params[:email])

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_back
		else
			@error = "Invalid E-mail and/or password."
			render :action => "show"
		end

	end

	def logout
		session[:user_id] = nil
		flash[:notice] = "You have been logged out."
		redirect_to root_path
	end
	
end
