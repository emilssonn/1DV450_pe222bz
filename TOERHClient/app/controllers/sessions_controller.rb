class SessionsController < ApplicationController
	protect_from_forgery :except => [:destroy]

	def index
    cookies[:key] = { key: ENV['OAUTH_ID'] }.to_json
		unless session[:user].nil?
			cookies[:user] = session[:user].to_json
			@logged_in = true
		else
			@logged_in = false
		end
	end
  
  def create
    auth = request.env["omniauth.auth"]
    
    session[:user] = {
			:id => auth['uid'],
    	:firstname => auth['info']['firstname'],
    	:lastname => auth['info']['lastname'],
    	:email => auth['info']['email'],
    	:token => auth['credentials']['token']
    }

    cookies[:user] = {
    	:id => auth['uid'],
    	:firstname => auth['info']['firstname'],
    	:lastname => auth['info']['lastname'],
    	:email => auth['info']['email'],
    	:token => auth['credentials']['token']
    }.to_json
    @logged_in = true
    redirect_to root_path
  end

  def destroy
  	session[:user] = nil
    head :no_content
  end

end
