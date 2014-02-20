class Api::V1::LicensesController < Api::V1::ApiBaseController
	
	def index
		@licenses = License.limit(@limit).offset(@offset)
			.by_name(params[:q])
	end

	def show
		@license = License.find_by_public_id(params[:id])

		if @license.nil?
			error = { 
	      status: 404,
	      message: "The license was not found.",
	      developerMessage: "The License with the id '#{params[:id]}' was not found."
    	}
			not_found_response_base(error)
		end
	end
end
