class Api::V1::LicensesController < Api::V1::ApiBaseController
	before_action :require_admin, :except => [:index, :show]
	
	def index
		@licenses = License.limit(@limit).offset(@offset)
			.by_name(params[:q])
	end

	def show
		@license = License.find_by_public_id(params[:id])

		if @license.nil?
			not_found_response and return
		end
	end

	# Requires a logged in admin
	
	def create
		@license = License.new(license_params)

		if @license.save
			render "show", :status => :created
		else
			invalid_response(@license)
		end		
	end

	def update
		unless @license = License.find_by_public_id(params[:id])
			not_found_response and return
		end
			
		if @license.update(license_params)
			render "api/v1/licenses/show", :status => :ok
		else
			invalid_response(@license)
		end		
	end

	def destroy
		unless license = License.find_by_public_id(params[:id])
			not_found_response and return
		end
		license.destroy
		head :ok
	end

	private

	def license_params
		params.permit(:name, :description, :url)
	end

	def not_found_response
		error = { 
	    status: 404,
	    message: "The license was not found.",
	    developerMessage: "The License with the id '#{params[:id]}' was not found."
   	}
		not_found_response_base(error)
	end
end
