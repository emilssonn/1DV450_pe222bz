class Api::ErrorsController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	def error_404
		error = { 
      status: 404,
      message: "Requested route not found.",
      developerMessage: "The requested Api end-point was not found."  
    }
    respond_to do |format|
      format.json { render :json => error.to_json, :status => :not_found }
      format.xml { render :xml => error.to_xml, :status => :not_found }
    end
	end	
end
