class Api::V1::ResourceTypesController < Api::V1::ApiBaseController
	before_action :require_admin, :except => [:index, :show]

	def index
		@resource_types = ResourceType.limit(@limit).offset(@offset)
			.by_name(params[:q])
	end

	def show
		@resource_type = ResourceType.find_by_public_id(params[:id])

		if @resource_type.nil?
			not_found_response and return
		end
	end

	# Requires a logged in admin
	
	def create
		@resource_type = ResourceType.new(resource_type_params)

		if @resource_type.save
			render "show", :status => :created
		else
			invalid_response(@resource_type)
		end		
	end

	def update
		unless @resource_type = ResourceType.find_by_public_id(params[:id])
			not_found_response and return
		end
			
		if @resource_type.update(resource_type_params)
			render "api/v1/resource_types/show", :status => :ok
		else
			invalid_response(@resource_type)
		end		
	end

	def destroy
		unless resource_type = ResourceType.find_by_public_id(params[:id])
			not_found_response and return
		end
		resource_type.destroy
		head :ok
	end

	private

	def resource_type_params
		params.permit(:name, :description)
	end

	def not_found_response
		error = { 
	    status: 404,
	    message: "The resource type was not found.",
	    developerMessage: "The ResourceType with the id '#{params[:id]}' was not found."
    }
		not_found_response_base(error)
	end
	
end
