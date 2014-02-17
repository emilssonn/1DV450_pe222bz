class Api::V1::ResourcesController < Api::V1::ApiBaseController
	before_action :require_token
	before_action :rate_limit_by_api_key, :only => [:index, :show]
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

		@resource = Resource.new(name: params[:name], description: params[:description], url: params[:url])
		@resource.valid?

		if !params[:resource_type_id]
			@resource.errors.add(:resource_type_id, "is required")
		else
			resource_type = ResourceType.find_by_public_id(params[:resource_type_id])
			if resource_type.nil?
				@resource.errors.add(:resource_type_id, "is not a valid id")
			else
				@resource.resource_type = resource_type
			end
		end

		if !params[:license_id]
			@resource.errors.add(:license_id, "is required")
		else
			license = License.find_by_public_id(params[:license_id])
			if license.nil?
				@resource.errors.add(:license_id, "is not a valid id")
			else
				@resource.license = license
			end
		end
		
		params[:tags].each do |t|
			tag = Tag.find_or_create_by(name: t)
			if tag.valid?
				@resource.tags << tag
			else
				@resource.errors.add(:tags, "fel")
			end

		end if params[:tags].is_a?(Array)


		if @resource.errors.empty?
			if @resource.save
				render "resources/show", :status => :created
			end
		else
			invalid_response(@resource)
		end		
		
	end

	def update
		@resource = Resource.find_by_public_id(params[:id])

		if @resource.nil?
			not_found_response
		end

		if params[:resource_type_id]
			resource_type = ResourceType.find_by_public_id(params[:resource_type_id])
			if resource_type.nil?
				@resource.errors.add(:resource_type_id, "is not a valid id")
			else
				@resource.resource_type = resource_type
			end
		end

		if params[:license_id]
			license = License.find_by_public_id(params[:license_id])
			if license.nil?
				@resource.errors.add(:license_id, "is not a valid id")
			else
				@resource.license = license
			end
		end
		
		params[:tags].each do |t|
			tag = Tag.find_or_create_by(name: t)
			if tag.valid?
				@resource.tags << tag
			else
				@resource.errors.add(:tags, "fel")
			end

		end if params[:tags].is_a?(Array)


		if @resource.errors.empty?
			if @resource.save
				render "resources/show", :status => :ok
			end
		else
			invalid_response(@resource)
		end		
	end

	def delete
		@resource = Resource.find_by_public_id(params[:id])

		if @resource.nil?
			not_found_response
		end

		head :ok
	end

	private

	def invalid_response(resource)
		respond_to do |format|
	    format.json { render :json => resource.errors.to_json, :status => :bad_request }
	    format.xml { render :xml => resource.errors.to_xml, :status => :bad_request }
    end
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
