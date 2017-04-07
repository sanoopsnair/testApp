module Admin
  class BrandsController < Admin::ResourceController

    def update_status
      @brand = Brand.find(params[:id])
      case params[:status]
      when "unpublished"
        @brand.unpublish!
      when "removed"
        @brand.remove!
      when "published"
        @brand.publish!
      end
      render :row
    end

    def mark_as_featured
      @brand = Brand.find(params[:id])
      @brand.update_attribute(:featured, true) if @brand.published?
      render :row
    end

    def remove_from_featured
      @brand = Brand.find(params[:id])
      @brand.update_attribute(:featured, false) if @brand.featured?
      render :row
    end

    private

    def permitted_params
      params[:brand].permit(:name, :priority)
    end

    def set_navs
      set_nav("admin/brands")
    end

    def get_collections
      @relation = Brand.where("")
      
      filter_param_mapping
      parse_filters
      apply_filters
      filter_config_ui
      
      @brands = @relation.order("priority ASC, name ASC").page(@current_page).per(@per_page)
      @total = @relation.count

      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
      @relation = @relation.status(@status) if @status
      @relation = @relation.featured(@featured) unless @featured.nil?
    end

    def filter_config
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
          display_hash: Brand::STATUS_HASH_REVERSE,
          current_value: @status,
          values: Brand::STATUS_HASH,
          current_filters: @filters,
          filters_to_remove: [],
          filters_to_add: {},
          url_method_name: 'admin_brands_url',
          show_all_filter_on_top: true
        },

        featured: {
          object_filter: false,
          select_label: "Filter by Featured",
          display_hash: Brand::FEATURED_HASH_REVERSE,
          current_value: @featured,
          values: Brand::FEATURED_HASH,
          current_filters: @filters,
          filters_to_remove: [],
          filters_to_add: {},
          url_method_name: 'admin_brands_url',
          show_all_filter_on_top: true
        }
      }
    end

  end
end
