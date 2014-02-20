class Api::V1::ResourceTypesController < Api::V1::ApiBaseController
	
	def index
		@resource_types = ResourceType.limit(@limit).offset(@offset)
			.by_name(params[:q])
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
