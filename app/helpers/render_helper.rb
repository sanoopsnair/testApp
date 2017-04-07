module RenderHelper
  	def render_or_redirect(error, redirect_url, action, notice=nil)
		respond_to do |format|
		  	format.html {
	    		if error
		      		render action: action
		    	else
		      		redirect_to redirect_url, notice: notice
		    	end
		  	}
		  	format.js {}
		end
  	end

  def render_list
    respond_to do |format|
      	format.html { get_collections and render :index }
      	format.js {}
    end
  end

  def render_show
    respond_to do |format|
      	format.js { render action: :show }
    end
  end
end