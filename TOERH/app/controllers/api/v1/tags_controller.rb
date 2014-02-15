class Api::V1::TagsController < Api::V1::ApiBaseController

	def index
		@limit = params[:limit] > 0 && params[:limit] < 50 ? params[:limit] : 30 rescue 30
		@offset = params[:offset] > 0 ? params[:offset] : 0 rescue 0
		@search = params[:q] || ""

		@tags = Tag.limit(@limit).offset(@offset).where('name like ?', @search)
	end

	def show
		@tag = Tag.find_by_public_id(params[:id])

		if @tag.nil?
			error = { 
	      status: 404,
	      message: "The tag  was not found.",
	      developerMessage: "The Tag with the id '#{params[:id]}' was not found."
    	}
			not_found_response_base(error)
		end
	end

end
