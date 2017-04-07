module Admin
  class UsersController < Admin::ResourceController

    def create
      @user = User.new
      @user.assign_attributes(permitted_params)
      #@user.assign_default_password_if_nil
      save_resource(@user)
      get_collections
    end

    def make_super_admin
      @user = User.find(params[:id])
      @user.update_attribute(:super_admin, true)
      render :row
    end

    def remove_super_admin
      @user = User.find(params[:id])
      @user.update_attribute(:super_admin, false)
      render :row
    end

    def update_status
      @user = User.find(params[:id])
      @user.update_attribute(:status, params[:status])
      render :row
    end

    def masquerade
      @user = User.find(params[:id])
      masquerade_as_user(@user)
    end

    private

    def get_collections
      # Fetching the users
      @relation = User.where("")
      
      @filters = {}
      if params[:query]
        @query = params[:query].strip
        @filters[:query] = @query
        @relation = @relation.search(@query) if !@query.blank?
      end

      if params[:status]
        @status = params[:status].strip
        @filters[:status] = @status
        @relation = @relation.status(@status) if !@status.blank?
      end

      unless @current_user.super_admin?
        @relation = @relation.where("super_admin IS FALSE")
      end

      @users = @relation.order("created_at desc").page(@current_page).per(@per_page)

      return true
    end

    def permitted_params
      params.require(:user).permit(:name, :username, :email, :designation, :phone, :password, :password_confirmation)
    end

    def set_navs
      set_nav("admin/users")
    end

  end
end
