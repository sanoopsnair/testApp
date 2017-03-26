class SessionsController < ApplicationController
	

	def sign_in
		puts "---------->>> #{@current_user}&&&&&&&&&&"
		current_user
		# redirect to appropriate page if current user exist or if not current user token is not expired
		redirect_to_appropriate_page_after_sign_in if @current_user && !@current_user.token_expired?
	end

	def create_session
		@registration_details = AuthenticationService.new(params)
		puts "%%%%%%%%%%%%%%"
		if @registration_details.error
			set_notification_messages(@registration_details.error, :error)
			redirect_or_popup_to_default_sign_in_page
			return
		else
			@user = @registration_details.user
			session[:id] = @user.id
			@current_user = @user
			set_notification_messages("authentication.logged_in", :success)
			redirect_to_appropriate_page_after_sign_in
			return
		end

	end
end


