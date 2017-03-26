module AuthenticationHelper   
	private

	def current_user
		puts "current_user !!!!"
		# if current user exist or assigne with user getting from httptoken
		@current_user ||= authenticate_with_http_token { |token, options| User.find_by(auth_token: token)}
	end

	# Returns the default URL to which the system should redirect the user after an unsuccessful attempt to authorise a resource/page
	def default_sign_in_url
		sign_in_url
	end

	# Method to handle the redirection after unsuccesful authentication
	# This method should also handle the redirection if it has come through a customer appliction for authentication
	# In that case, it should persist the params passed by the customer application
	def redirect_after_unsuccessful_authentication
		params_hsh = {}
		params_hsh[:customer_app] = params[:customer_app] if params[:customer_app]
		params_hsh[:redirect_back_url] = params[:redirect_back_url] if params[:redirect_back_url]
		redirect_to add_query_params(default_sign_in_url, params_hsh)
		return
  	end

	def default_redirect_url_after_sign_in
		admin_dashboard_url    
	end

	def redirect_or_popup_to_default_sign_in_page
    	respond_to do |format|
	      	format.html {
	        	redirect_after_unsuccessful_authentication
	      	}
	      	format.js {
	    		render(:partial => 'sessions/popup_sign_in_form.js.erb', :handlers => [:erb], :formats => [:js])
	      	}
    	end
  	end

  	# This method is usually used as a before filter to secure some of the actions which requires the user to be signed in.
	def require_user
    	current_user
    	if @current_user
      		if @current_user.token_expired?
       			#binding.pry
        		@current_user = nil
        		session.delete(:id)
        		set_notification_messages("authentication.session_expired", :error)
        		redirect_or_popup_to_default_sign_in_page
        		return
      		end
    	else
      		set_notification_messages("authentication.permission_denied", :error)
      		redirect_or_popup_to_default_sign_in_page
      		return
    	end
  	end

	def redirect_to_appropriate_page_after_sign_in
		puts "???????????????????"
		if params[:redirect_back_url]
			puts "111111111"
			redirect_to params[:redirect_back_url]+"?auth_token=#{@current_user.auth_token}"
		else
			puts "22222222222222"
			redirect_to default_redirect_url_after_sign_in
		end
		return
	end
	
	
end