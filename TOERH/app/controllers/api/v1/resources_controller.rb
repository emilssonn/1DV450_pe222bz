class Api::V1::ResourcesController < Api::V1::ApiBaseController
	before_action :require_login, :except => [:index, :show]

	def index
		@limit = params[:limit] > 0 && params[:limit] < 50 ? params[:limit] : 30 rescue 30
		@offset = params[:offset] > 0 ? params[:offset] : 0 rescue 0

		@resources = Resource.limit(@limit).offset(@offset)
			.by_name(params[:q])
			.by_resource_type_ids(params[:resource_type_ids])
			.by_license_ids(params[:license_ids])
			.by_user_ids(params[:user_ids])
			.by_tags(params[:tags])

	end

	def show
		@resource = Resource.find_by_public_id(params[:id])

		if @resource.nil?
			not_found_response
		end
	end


	# Requires a logged in user
	
	def create

		@resource = Resource.new(create_params)


		puts create_params

		if @resource.save
			
		else
			respond_to do |format|
	      format.json { render :json => @resource.errors.to_json, :status => :not_found }
	      format.xml { render :xml => error.to_xml, :status => :not_found }
    	end
		end

		
		#resourceType = ResourceType.find_by_public_id()
	end

	def edit

	end

	def update

	end

	def delete

	end

	private

	def create_params
		params.fetch(:resource, {}).permit(
			:name, 
			:description, 
			:url, 
			:resource_type_id,
			:license_id,
			:tags => []
		)
	end

	def invalid_response

	end

	def not_found_response
		error = { 
			status: 404,
			message: "The resource not found.",
			developerMessage: "The Resource with the id '#{params[:id]}' was not found."
		}
		not_found_response_base(error)
	end

	

end
