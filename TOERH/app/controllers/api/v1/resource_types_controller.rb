class Api::V1::ResourceTypesController < Api::V1::ApiBaseController
	
	def index
		@limit = params[:limit] > 0 && params[:limit] < 50 ? params[:limit] : 30 rescue 30
		@offset = params[:offset] > 0 ? params[:offset] : 0 rescue 0
		@search = params[:q] || ""

		@resource_types = ResourceType.limit(@limit).offset(@offset).where('name like ?', @search)
	end

	def show
		@resource_type = ResourceType.find_by_public_id(params[:id])

		if @resource_type.nil?
			error = { 
	      status: 404,
	      message: "The resource type was not found.",
	      developerMessage: "The ResourceType with the id '#{params[:id]}' was not found."
    	}
			not_found_response_base(error)
		end
	end
	
end
