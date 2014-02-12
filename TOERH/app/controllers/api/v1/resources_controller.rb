class Api::V1::ResourcesController < Api::V1::ApiBaseController

	def index
		@resources = Resource.all
	end

	def show
		
	end


	# Requires a logged in user

	def edit

	end

	def update

	end

	def delete

	end

end
