class Admin::BaseController < ApplicationController
	layout 'admin/resource'

    before_action :require_user
    # before_action :require_admin

    private

    def set_default_title
      set_title("Admin | Golden Pioneer General Trading")
    end

    def stylesheet_filename
      @stylesheet_filename = "admin"
    end

    def javascript_filename
      @javascript_filename = "admin"
    end 
	
end
