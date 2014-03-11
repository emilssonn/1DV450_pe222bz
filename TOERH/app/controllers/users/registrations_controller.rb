class Users::RegistrationsController < ApplicationController
	layout "developers"

	def new
		if !current_user.nil?
			redirect_to root_path
		end
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			session[:user_id] = @user.id
			redirect_to root_path
		else
			render :new
		end
	end

	private

	def user_params
		params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
	end
end
