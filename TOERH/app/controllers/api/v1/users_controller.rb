class Api::V1::UsersController < Api::V1::ApiBaseController
	
	def index
		@users = User.limit(@limit).offset(@offset)
			.by_name(params[:q])
	end

	def show
		@user = User.find_by_public_id(params[:id])

		if @user.nil?
			error = { 
	      status: 404,
	      message: "The user  was not found.",
	      developerMessage: "The User with the id '#{params[:id]}' was not found."
    	}
			not_found_response_base(error)
		end
	end
end
