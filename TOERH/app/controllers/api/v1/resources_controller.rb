class Api::V1::ResourcesController < Api::V1::ApiBaseController
	doorkeeper_for :all, except: [:index, :show]
	before_action :transform_ids, :only => [:create, :update]
	before_action :find_resource, :only => [:update, :show, :destroy]
	

	def index
		@resources = Resource.limit(@limit).offset(@offset)
			.by_name(params[:q])
			.by_resource_type_ids(params[:resource_type_ids])
			.by_license_ids(params[:license_ids])
			.by_user_ids(params[:user_ids])
			.by_tags(params[:tags])
			.by_user(params[:user])

		@total = Resource.count
	end

	def show
		
	end

	# Requires a user
	
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
		if @resource.user_id != current_user.id
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
		if @resource.user_id != current_user.id
			not_found_response and return
		end
		@resource.destroy
		head :no_content
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
		params.permit(:name, :description, :url, :resource_type_id, :license_id, :user)
	end

	def transform_ids
		params[:license_id] = License.select(:id).find_by_public_id(params[:license_id]).id rescue 0 if params[:license_id]
    params[:resource_type_id] = ResourceType.select(:id).find_by_public_id(params[:resource_type_id]).id rescue 0 if params[:resource_type_id]
	end

	def not_found_response
		error = { 
			status: 404,
			message: "The resource was not found.",
			developerMessage: "The Resource with the id '#{params[:id]}' was not found."
		}
		not_found_response_base(error)
	end

	def find_resource
		unless @resource = Resource.find_by_public_id(params[:id])
			not_found_response and return
		end
	end

end
