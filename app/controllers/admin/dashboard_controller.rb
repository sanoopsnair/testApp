module Admin
	class DashboardController < Admin::BaseController

    	# GET /dashboard
		def index
		end

    	private

    	def set_navs
      		set_nav("admin/dashboard")
    	end

  	end
end

