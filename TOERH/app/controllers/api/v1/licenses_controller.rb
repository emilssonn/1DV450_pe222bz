class Api::V1::LicensesController < Api::V1::ApiBaseController
	
	def index
		@limit = params[:limit] > 0 && params[:limit] < 50 ? params[:limit] : 30 rescue 30
		@offset = params[:offset] > 0 ? params[:offset] : 0 rescue 0
		@search = params[:q] || ""

		@licenses = License.limit(@limit).offset(@offset).where('name like ?', @search)
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
