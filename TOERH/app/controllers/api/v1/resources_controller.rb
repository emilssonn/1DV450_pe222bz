class Api::V1::ResourcesController < Api::V1::ApiBaseController
	before_action :require_login, :except => [:index, :show]
	

	def index
		@limit = params[:limit] > 0 && params[:limit] < 50 ? params[:limit] : 30 rescue 30
		@offset = params[:offset] >= 0 ? params[:offset] : 0 rescue 0

		@resources = Resource.limit(@limit).offset(@offset)
			.by_name(params[:q])
			.by_resource_type_ids(params[:resource_type_ids])
			.by_license_ids(params[:license_ids])
			.by_user_ids(params[:user_ids])
			.by_tags(params[:tags])

		puts @resources[0].tags.to_json
	end

	def show
		unless @resource = Resource.find_by_public_id(params[:id])
			not_found_response
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
			not_found_response
		end

		@resource.tags.clear

		get_tags
		
		if @resource.errors.empty?
			if @resource.save
				render "resources/show", :status => :ok
			end
		else
			invalid_response(@resource)
		end		
	end

	def delete
		unless resource = Resource.find_by_public_id(params[:id])
			not_found_response
		end

		resource.destroy
		head :ok
	end

	private

	def get_tags
		params[:tags].each do |t|
			tag = Tag.find_or_create_by(name: t)
			if tag.valid?
				@resource.tags << tag
			else
				@resource.errors.add(:tags, "fel")
			end

		end if params[:tags].is_a?(Array)
	end

	def resource_params
		params.permit(:name, :description, :url, :resource_type_id, :license_id)
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
