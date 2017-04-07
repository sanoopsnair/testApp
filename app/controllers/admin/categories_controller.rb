module Admin
	class CategoriesController < Admin::ResourceController
	    def update_status
	      	@category = Category.find(params[:id])
	      	case params[:status]
	      	when "unpublished"
	        	@category.unpublish!
	      	when "removed"
	        	@category.remove!
	      	when "published"
	        	@category.publish!
	      	end
	      	render :row
	    end

	    def make_parent
	  		@category = Category.find(params[:id])
	      	@category.update_attribute(:parent_id, nil)
	      	get_collections
	      	render :index
	    end

	    def mark_as_featured
	      	@category = Category.find(params[:id])
	      	@category.update_attribute(:featured, true) if @category.published?
	      	render :row
	    end

	    def remove_from_featured
	      	@category = Category.find(params[:id])
	      	@category.update_attribute(:featured, false) if @category.featured?
	      	render :row
	    end

	    private

	    def permitted_params
	      	params[:category].permit(:name, :permalink, :one_liner, :description, :parent_id, :priority)
	    end

	    def set_navs
	      	set_nav("admin/categories")
	    end

	    def get_collections
	  		puts "---- 3----"
	      	@relation = Category.where("parent_id IS NULL").order("priority ASC, name ASC")
	      	#@relation = Category.select("categories.*, catg.name as category_name").
	                    #joins("LEFT JOIN categories catg ON categories.parent_id = catg.id").
	                    #order("created_at DESC")
	      
	      	filter_param_mapping
	      	parse_filters
	      	apply_filters
	      	filter_config_ui
	      
	      	@categories = @relation.page(@current_page).per(@per_page)
	      
	      	return true
	    end

	    def apply_filters
	      	@relation = @relation.search(@query) if @query
	      	@relation = @relation.status(@status) if @status
	      	@relation = @relation.featured(@featured) unless @featured.nil?
	    end

	    def filter_config
	      	puts "----- filter config -"
	      	@filter_config = {
		        boolean_filters: [
		          { filter_name: :featured }
		        ],
		        string_filters: [
		          { filter_name: :query },
		          { filter_name: :status }
		        ],
		        reference_filters: [],
		        variable_filters: [],
	      	}
	    end

	    def filter_config_ui

	      	@filter_config_ui = {
		        status: {
		          object_filter: false,
		          select_label: "Filter by Status",
		          display_hash: Category::STATUS_HASH_REVERSE,
		          current_value: @status,
		          values: Category::STATUS_HASH,
		          current_filters: @filters,
		          filters_to_remove: [],
		          filters_to_add: {},
		          url_method_name: 'admin_categories_url',
		          show_all_filter_on_top: true
		        },

		        featured: {
		          object_filter: false,
		          select_label: "Filter by Featured",
		          display_hash: Product::FEATURED_HASH_REVERSE,
		          current_value: @featured,
		          values: Product::FEATURED_HASH,
		          current_filters: @filters,
		          filters_to_remove: [],
		          filters_to_add: {},
		          url_method_name: 'admin_products_url',
		          show_all_filter_on_top: true
		        },
	      	}
	    end
	end
end