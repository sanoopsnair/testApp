class AuthenticationService
	attr_reader :login_handle, :password, :error, :user

	def initialize(params)
		@login_handle = params[:login_handle]
		@password = params[:password]
		@error = nil

		check_if_user_exists   #is user exist
		if @user
			puts "--- @user #{@user.inspect}"
      		authenticate
      		check_if_user_is_active
		end

		@user.start_session unless @error

	end 



	def invalid_login_error
		"authentication.invalid_login"
	end


	def check_if_user_exists
		@user = User.where("LOWER(email) = LOWER('#{@login_handle}') OR LOWER(username) = LOWER('#{@login_handle}')").first
		set_error(invalid_login_error) unless @user
		
	end

	def check_if_user_is_active
    	set_error(user_status_error) unless @user.active?
  	end

	def authenticate
		set_error(invalid_login_error) unless @user.authenticate(@password)
	end


	def set_error(id)
		@error ||= id
	end
end