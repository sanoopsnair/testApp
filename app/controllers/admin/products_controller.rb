module Admin
  class ProductsController < Admin::ResourceController

    def create
      @product = Product.new
      @product.assign_attributes(permitted_params)
      save_resource(@product)
      render :row
    end

    def update
      @product = Product.find(params[:id])
      @product.assign_attributes(permitted_params)
      save_resource(@product)
      render :row
    end

    def update_status
      @product = Product.find(params[:id])
      case params[:status]
      when "unpublished"
        @product.unpublish!
      when "removed"
        @product.remove!
      when "published"
        @product.publish!
      end
      render :row
    end

    def mark_as_featured
      @product = Product.find(params[:id])
      @product.update_attribute(:featured, true) if @product.published?
      render :row
    end

    def remove_from_featured
      @product = Product.find(params[:id])
      @product.update_attribute(:featured, false) if @product.featured?
      render :row
    end

    private

    def permitted_params
      params[:product].permit(:name, :permalink, :one_liner, :description, :brand_id, :category_id, :priority)
    end

    def set_navs
      set_nav("admin/products")
    end

    def get_collections
      @relation = Product.where("")
      
      filter_param_mapping
      parse_filters
      apply_filters
      filter_config_ui
      
      @products = @relation.order("priority ASC, name ASC").page(@current_page).per(@per_page)
      @total = @relation.count

      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
      @relation = @relation.status(@status) if @status
      @relation = @relation.featured(@featured) unless @featured.nil?

      if @brand == "null"
        @relation = @relation.where("products.brand_id IS NULL")
      elsif @brand
        @relation = @relation.where("products.brand_id = ?",@brand.id)
      end

      if @category == "null"
        @relation = @relation.where("products.category_id IS NULL")
      elsif @category
        @relation = @relation.where("products.category_id = ?",@category.id)
      end

      if @top_category == "null"
        @relation = @relation.where("products.top_category_id IS NULL")
      elsif @top_category
        @relation = @relation.where("products.top_category_id = ?",@top_category.id)
      end
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
        reference_filters: [
          { filter_name: :brand, filter_class: Brand },
          { filter_name: :top_category, filter_class: Category },
          { filter_name: :category, filter_class: Category }
        ],
        variable_filters: [],
      }
    end

    def filter_config_ui

    	brands = Brand.select("id, name").order("brands.name ASC").all
      categories = Category.select("id, name").order("name ASC").all
      top_categories = Category.select("id, name").where("parent_id IS NULL").order("name ASC").all

      @filter_config_ui = {
        status: {
          object_filter: false,
          select_label: "Filter by Status",
          display_hash: Product::STATUS_HASH_REVERSE,
          current_value: @status,
          values: Product::STATUS_HASH,
          current_filters: @filters,
          filters_to_remove: [],
          filters_to_add: {},
          url_method_name: 'admin_products_url',
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

        brand: {
          object_filter: true,
          select_label: 'Select Brand',
          current_value: @brand,
          values: brands,
          current_filters: @filters,
          url_method_name: 'admin_products_url',
          filters_to_remove: [],
          filters_to_add: {},
          show_null_filter_on_top: true
        },

        category: {
          object_filter: true,
          select_label: 'Select Category',
          current_value: @category,
          values: categories,
          current_filters: @filters,
          url_method_name: 'admin_products_url',
          filters_to_remove: [],
          filters_to_add: {},
          show_null_filter_on_top: true
        },

        top_category: {
          object_filter: true,
          select_label: 'Select Top Category',
          current_value: @top_category,
          values: top_categories,
          current_filters: @filters,
          url_method_name: 'admin_products_url',
          filters_to_remove: [],
          filters_to_add: {},
          show_null_filter_on_top: true
        },

      }
    end

  end
end
