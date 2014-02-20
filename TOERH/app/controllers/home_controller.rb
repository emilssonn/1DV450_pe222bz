class HomeController < ApplicationController
	def index
		redirect_to subdomain: 'developers'
	end
end
