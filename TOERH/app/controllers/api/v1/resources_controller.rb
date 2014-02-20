class Api::V1::ResourcesController < Api::V1::ApiBaseController
	before_action :require_login, :except => [:index, :show]
	before_action :transform_ids, :only => [:create, :update]
	

	def index
		@resources = Resource.limit(@limit).offset(@offset)
			.by_name(params[:q])
			.by_resource_type_ids(params[:resource_type_ids])
			.by_license_ids(params[:license_ids])
			.by_user_ids(params[:user_ids])
			.by_tags(params[:tags])
	end

	def show
		unless @resource = Resource.find_by_public_id(params[:id])
			not_found_response and return
		end
	end

	# Requires a logged in user
	
	def create
		@resource = Resource.new(resource_params)
		@resource.user = current_user
		@resource.valid?

		get_tags

		if @resource.errors.empty? && @resource.save
			render "show", :status => :created
		else
			invalid_response(@resource)
		end		
	end

	def update
		unless @resource = Resource.find_by_public_id(params[:id])
			not_found_response and return
		end
		@resource.tags.clear

		get_tags
			
		if @resource.errors.empty? && @resource.update(resource_params)
			render "api/v1/resources/show", :status => :ok
		else
			invalid_response(@resource)
		end		
	end

	def destroy
		unless resource = Resource.find_by_public_id(params[:id])
			not_found_response and return
		end
		resource.destroy
		head :ok
	end

	private

	# Get each tag
	# Add errors to the resource object
	def get_tags
		params[:tags].each do |t|
			tag = Tag.find_or_create_by(name: t)
			if tag.valid?
				@resource.tags << tag
			else
				@resource.errors.add(:tags, {tag.name => tag.errors})
			end
		end if params[:tags].is_a?(Array)
	end

	def resource_params
		params.permit(:name, :description, :url, :resource_type_id, :license_id)
	end

	def transform_ids
		params[:license_id] = License.select(:id).find_by_public_id(params[:license_id]).id rescue 0 if params[:license_id]
    params[:resource_type_id] = ResourceType.select(:id).find_by_public_id(params[:resource_type_id]).id rescue 0 if params[:resource_type_id]
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
