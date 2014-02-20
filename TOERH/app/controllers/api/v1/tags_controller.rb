class Api::V1::TagsController < Api::V1::ApiBaseController

	def index
		@tags = Tag.limit(@limit).offset(@offset)
			.by_name(params[:q])
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
