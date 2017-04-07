module Admin
	class ResourceController < Admin::BaseController
		before_action :configure, :filter_config  # use of :filter_config ?

		include ResourceHelper
	end
end

