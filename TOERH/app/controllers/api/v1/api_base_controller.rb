#
# All calls to the Api requires a valid Api key, this is checked in app/middleware/rate_limit.rb
#
class Api::V1::ApiBaseController < ActionController::Base
	#rescue_from StandardError, :with => :error_render_method

	private

  def error_render_method
    
    
  end

end
