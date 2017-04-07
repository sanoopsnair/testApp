module ResourceHelper

  def index
    puts"------RH index--------"
    get_collections
  end

  def show
    puts "----RH show---"
    obj = @options[:class].find(params[:id])
    instance_variable_set("@#{@options[:item_name]}", obj)
    render_list
  end

  def new
    puts "----RH new---"
    obj = @options[:class].new
    instance_variable_set("@#{@options[:item_name]}", obj)
    render_list
  end

  def edit
    puts "----RH edit---"
    obj = @options[:class].find(params[:id])
    instance_variable_set("@#{@options[:item_name]}", obj)
    render_list
  end

  def create
    puts "----RH create---"
    obj = @options[:class].new
    obj.assign_attributes(permitted_params)
    instance_variable_set("@#{@options[:item_name]}", obj)
    save_resource(obj)
  end

  def update
    puts "----RH update---"
    obj = @options[:class].find(params[:id])
    obj.assign_attributes(permitted_params)
    instance_variable_set("@#{@options[:item_name]}", obj)
    save_resource(obj)
  end

  def destroy
    puts "----RH destroy---"
    obj = @options[:class].find(params[:id])
    instance_variable_set("@#{@options[:item_name]}", obj)
    if obj.can_be_destroyed?
      obj.destroy
      get_collections
      set_flash_message(@options[:messages][:delete], :success)
      @destroyed = true
    else
      set_flash_message("Cannot remove! Remove the dependant data first", :failure)
      @destroyed = false
    end
  end

  private

  def set_navs
    puts "----RH set_navs---"
    set_nav(params[:controller])
  end

  def permitted_params
    puts "----RH permitted_params---"
    raise "method 'permitted_params' not defined"
  end

  def default_collection_name
    puts "----RH default_collection_name---"
    params[:controller].split("/").last
  end

  def default_item_name
    puts "----RH default_item_name---"
    default_collection_name.singularize.gsub("_", " ")
    # puts " ----default_item_name -- #{default_collection_name.singularize.gsub('_', ' ')}"
  end

  def default_class
    puts "----RH default_class---"
    default_collection_name.singularize.camelize.constantize
    # puts "--- default_class --  #{default_collection_name.singularize.camelize.constantize}"
  end

  def default_configuration
    puts "----RH default_configuration---"
    # puts "---params[:controller]--- #{params[:controller]}"
    # puts " --- default_collection_name -- #{default_collection_name}"
    # puts " --- default_item_name -- #{default_item_name}"
    # puts " --- default_class -- #{default_class}"
    {
      collection_name: default_collection_name,
      item_name: default_item_name,
      class: default_class,
      layout: :table,
      messages: {
        add: I18n.translate("forms.add", item: default_item_name.titleize),
        create: I18n.translate("forms.create", item: default_item_name.titleize),
        update: I18n.translate("forms.update", item: default_item_name.titleize),
        save: I18n.translate("forms.save", item: default_item_name.titleize),
        remove: I18n.translate("forms.remove", item: default_item_name.titleize),
        delete: I18n.translate("forms.delete",item:  default_item_name.titleize)
      }
    }
  end

  def configure
    puts "----RH configure---"
    if defined?(@options)
      @options.reverse_merge!(default_configuration)
    else
      @options = default_configuration
      # puts "--- #{@options}"
      # puts "--- #{@options.class}"
      # puts "--- #{@options.class.name}"
    end
  end

  def prepare_query
    puts "------RH prepare_query----"
    # puts "--- params[:query] - #{params[:query]}"
    @relation = @options[:class].where("")
    if params[:query]
      @query = params[:query].strip
      # puts "---- @query #{@query}"
      @relation = @relation.search(@query) if !@query.blank?
    end
  end

  def get_collections
    puts"----------RH get_collections --2--------"
    prepare_query
    objects = @relation.order("created_at desc").page(@current_page).per(@per_page)
    instance_variable_set("@#{@options[:collection_name]}", objects)
    unless instance_variable_get("@#{@options[:item_name]}")
      instance_variable_set("@#{@options[:item_name]}", objects.first)
    end
    return true
  end

  def resource_url(obj)
    puts "----RH resource_url---"
    url_for([:admin, obj])
  end

  def save_resource(obj)
    puts "----RH save_resource---"
    obj.save
    if obj.errors.blank?
      get_collections if @options[:layout] = :table
      set_flash_message(@options[:messages][:save], :success) 
    end
    action_name = params[:action].to_s == "create" ? "new" : "edit"
    url = obj.persisted? ? resource_url(obj) : nil
    render_or_redirect(obj.errors.any?, url, action_name)
  end

end