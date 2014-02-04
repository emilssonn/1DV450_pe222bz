class Developers::Users::AuthorizationsController < ApplicationController
	layout "developers"
	
	def show
		if !current_user.nil?
			redirect_to root_path
		end
	end

	def signIn
		user = User.find_by_email(params[:email])

		if user && user.authenticate(params[:password])
			session[:userid] = user.id
			redirect_to applications_path
		else
			flash.now[:error] = "Invalid"
			render :action => "show"
		end

	end

	def signOut
		session[:userid] = nil
		flash[:message] = "You have been logged out."
		redirect_to root_path
	end
	
end
