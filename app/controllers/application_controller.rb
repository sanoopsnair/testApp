class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	include AuthenticationHelper
	include FlashHelper
	include NotificationHelper
	include UrlHelper
	include TitleHelper
	include ResourceHelper
	include NavigationHelper
	include MetaTagsHelper
	# include ParamsParserHelper

  	## This filter method is used to fetch current user
  	before_action :current_user, :set_default_title, :set_navs,
                :stylesheet_filename, :javascript_filename 
                

    private
  	def filter_param_mapping
    	return @filter_param_mapping if @filter_param_mapping
    	@filter_param_mapping = {

		      code: :code,
		      permalink: :permalink,

		      query: :q,
		      chart_type: :ct,
		      status: :st,
		      featured: :fd,
		      month: :mn,
		      year: :yr,

		      country: :cn,
		      city: :cy,

		      brand: :br,
		      news: :nw,
		      category: :ct,
		      top_category: :tc,
		      
		      company: :co,
		      company_group: :cg,

		      to_year: :ty,
		      from_year: :fy,

		      account_group: :ag,
		      account_type: :at,
		      parent: :parent
    	}
  	end

	def set_default_title
		set_title("Golden Pioneer General Trading")
	end
end
