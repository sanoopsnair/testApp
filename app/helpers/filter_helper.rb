# This module creates basic reporting UI elements like filter drop downs etc
module FilterHelper
    
  def filter_config_ui
    return @filter_config_ui if @filter_config_ui
    @filter_config_ui = {}
  end

  def filter_config
    @filter_config = {
      boolean_filters: [],
      string_filters: [
        { filter_name: :query }
      ],
      reference_filters: [],
      variable_filters: [],
    }
  end

  # Example
  # <%= 
  #     report_filter(
  #       select_label: "To",
  #       param_name: 'to_year',
  #       current_value: @to_year,
  #       values: Array(2000..(Date.today.year)).reverse,
  #       current_filters: @filters,
  #       filters_to_remove: [],
  #       filters_to_add: {permalink: @current_company_group.permalink, code: @company.code},
  #       url_method_name: 'company_dashboard_url',
  #       show_all_filter_on_top: false,
  #     )
  #   %>
  
  def report_filter(filter_name, **filter_options)
    filter_options.reverse_merge!(
      select_label: "Select Filter",
      display_hash: {},
      current_value: nil,
      values: {},
      current_filters: {},
      filters_to_remove: [],
      filters_to_add: {},
      url_method_name: 'root_path',
      show_all_filter_on_top: true,
      show_null_filter_on_top: false
    )

    raise "@filter_param_mapping not initialised" unless @filter_param_mapping
    raise "#{filter_name} is not added to @filter_param_mapping" unless @filter_param_mapping.has_key?(filter_name)

    param_name = @filter_param_mapping[filter_name]

    # The text to be displayed will be judged based on the arguments
    # If display_hash is passed and is a valid Hash, it will search for the current_value as key
    # for e.g: if display_hash = {1: "Dog", 2: "Cat"} and current_value is 2, it will display "Cat"
    # If display_hash is not passed, it will simple display current_value

    display_hash = filter_options[:display_hash].stringify_keys
    
    if display_hash.empty?
      selected_text = filter_options[:current_value]
    else
      selected_text = display_hash[filter_options[:current_value].to_s]
    end
    selected_text = filter_options[:select_label] unless selected_text

    # The link should populate a url which has all the current filters
    # It should also be removing the filters which are not required for the next level
    # It should also filter case by case.

    # Clone the existing filters first
    # remove the filters which are to be removed and add which are to be added
    # Also remove the filter which is currently selected
    filter_options[:filters_to_remove] << filter_name.to_sym

    # filters is now a hash with keys looking like year, month etc.
    # However, we need a hash with keys in short form like yr, mn
    # creating the new hash which we need
    filters = generate_short_url_filters(filter_options[:current_filters], filter_options[:filters_to_add], filter_options[:filters_to_remove])

    initial_list = {}
    initial_list["All"] = send(filter_options[:url_method_name], filters) if filter_options[:show_all_filter_on_top]
    initial_list["IS NOT SET"] = send(filter_options[:url_method_name], filters.merge({param_name => :null})) if filter_options[:show_null_filter_on_top]
    
    # Values can be either Array or Hash
    # If Array is passed, it will populate the Hash it want from the Hash
    # For e.g: if values = ["Jan", "Feb"], theh the hash populated would be {"Jan" => "Jan", "Feb" => "Feb"}
    # This is done as it needs one display value and one passing value
    
    if filter_options[:values].is_a?(Array)
      filter_options[:values] = filter_options[:values].inject({}) do |results, item|
        results[item] = item
        results
      end
    end

    options = filter_options[:values].inject(initial_list) do |results, (name, value)| 
      filters.reject!{|k,v| k == filter_name.to_sym }
      results[name] = {param_name => value}.reverse_merge(filters)
      results
    end

    drop_down_filter(selected_text, options)

  end

  # Example
  # <%= 
  #     report_object_filter(
  #       select_label: 'Select City',
  #       param_name: 'city',
  #       current_value: @city,
  #       values: City.order(:name).all,
  #       current_filters: @filters,
  #       url_method_name: 'company_dashboard_url',
  #       filters_to_add: {permalink: @current_company_group.permalink, code: @company.code},
  #     )
  #   %>

  def report_object_filter(filter_name, **filter_options)
    filter_options.reverse_merge!(
      select_label: 'Select Filter',
      current_value: nil,
      values: [],
      current_filters: {},
      url_method_name: 'root_path',
      filters_to_add: {},
      filters_to_remove: [],
      show_all_filter_on_top: true,
      show_null_filter_on_top: false,
      display_method: :display_name
    )

    raise "@filter_param_mapping not initialised" unless @filter_param_mapping
    raise "#{filter_name} is not added to @filter_param_mapping" unless @filter_param_mapping.has_key?(filter_name)

    param_name = @filter_param_mapping[filter_name]

    if filter_options[:current_value].to_s == "null"
      selected_text = "#{filter_name.to_s.titleize} IS NOT SET"
    elsif filter_options.has_key?(:display_method) && filter_options[:current_value]
      selected_text = filter_options[:current_value].send(filter_options[:display_method])
    end
    selected_text = filter_options[:select_label] unless selected_text

    # Clone the existing filters firs
    # remove the filters which are to be removed and add which are to be added
    # Also remove the filter which is currently selected
    temp_filters = filter_options[:current_filters].clone
    temp_filters.merge!(filter_options[:filters_to_add])
    temp_filters.reject!{|k,v| filter_options[:filters_to_remove].include?(k)}
    temp_filters.reject!{|k,v| k == filter_name.to_sym }

    # filters is now a hash with keys looking like year, month etc.
    # However, we need a hash with keys in short form like yr, mn
    # creating the new hash which we need
    filters = {}
    temp_filters.each do |k,v|
      short_k = @filter_param_mapping[k]
      filters[short_k] = v
    end

    initial_list = {}
    initial_list["All"] = send(filter_options[:url_method_name], filters) if filter_options[:show_all_filter_on_top]
    initial_list["IS NOT SET"] = send(filter_options[:url_method_name], filters.merge({param_name => :null})) if filter_options[:show_null_filter_on_top]
    
    options = filter_options[:values].inject(initial_list) do |results, item| 
      display_value = item.send(filter_options[:display_method])
      filters = {param_name => item}.reverse_merge(filters)
      results[display_value] = send(filter_options[:url_method_name], filters)
      results
    end

    drop_down_filter(selected_text, options)
  end

  def generate_short_url_filters(filters, filters_to_add, filters_to_remove)
    # Clone the existing filters first
    # remove the filters which are to be removed and add which are to be added
    # Also remove the filter which is currently selected
    temp_filters = filters.clone
    temp_filters.merge!(filters_to_add) unless filters_to_add.blank?
    temp_filters.reject!{|k,v| filters_to_remove.include?(k)} unless filters_to_remove.blank?

    # filters is now a hash with keys looking like year, month etc.
    # However, we need a hash with keys in short form like yr, mn
    # creating the new hash which we need
    short_filters = {}
    temp_filters.each do |k,v|
      short_k = @filter_param_mapping[k]
      short_filters[short_k] = v
    end
    short_filters
  end

  def parse_string_filter(param_name, default_value=nil)
    obj = params[param_name.to_sym] ? params[param_name.to_sym].strip : default_value
    instance_variable_set("@#{param_name}", obj)
    @filters[param_name.to_sym] = obj unless obj.blank?
  end

  ##### 

  def filter_config
    return @filter_config if @filter_config
    @filter_config = {
      variable_filters: [
        { variable_name: :current_company_group, filter_name: :company_group, options: {} },
        { variable_name: :current_company, filter_name: :company, options: {} }
      ],
      boolean_filters: [],
      string_filters: [
        { param_name: :q, filter_name: :query, options: {} }
      ],
      reference_filters: [
        { param_name: :b, filter_name: :brand, filter_class: Brand, options: {}}
      ]
    }
  end

  def parse_filters

    @filters = {} unless @filters

    filter_config[:variable_filters].each do |vf|
      options = vf[:options] || {}
      parse_filter_from_variable(vf[:variable_name], vf[:filter_name], options)
    end if filter_config.has_key?(:variable_filters)

    filter_config[:string_filters].each do |spf|
      options = spf[:options] || {}
      parse_string_filter_from_params(spf[:filter_name], options)
    end if filter_config.has_key?(:string_filters)

    filter_config[:boolean_filters].each do |spf|
      options = spf[:options] || {}
      parse_boolean_filter_from_params(spf[:filter_name], options)
    end if filter_config.has_key?(:boolean_filters)

    filter_config[:reference_filters].each do |rpf|
      options = rpf[:options] || {}
      parse_reference_filter_from_params(rpf[:filter_name], rpf[:filter_class], options)
    end if filter_config.has_key?(:reference_filters)
  end

  
  # Use this method to create a filter if the value is in a variable
  # e.g: if @current_user has a user object as value i.e <obj: "Mike">
  # parse_filter_from_variable(:current_company_group, :company_group)
  def parse_filter_from_variable(variable_name, filter_name, **options)
    variable = instance_variable_get("@#{variable_name}")
    @filters[filter_name] = variable if variable
  end

  # parse_string_filter_from_params(:q, :query)
  def parse_string_filter_from_params(filter_name, **options)
    raise "@filter_param_mapping not initialised" unless @filter_param_mapping
    raise "#{filter_name} is not added to @filter_param_mapping" unless @filter_param_mapping.has_key?(filter_name)

    param_name = @filter_param_mapping[filter_name]
    
    case params[param_name]
    when Array
      obj = params[param_name].uniq.compact
      instance_variable_set("@#{filter_name}", obj)
      @filters[filter_name] = obj if obj  
    when String
      obj = params[param_name].strip
      instance_variable_set("@#{filter_name}", obj)
      @filters[filter_name] = obj if obj  
    when nil
      if options[:default]
        obj = options[:default]
        instance_variable_set("@#{filter_name}", options[:default])
        @filters[filter_name] = options[:default]
      end
    end
  end

  # parse_boolean_filter_from_params(:fd, :featured)
  def parse_boolean_filter_from_params(filter_name, **options)
    raise "@filter_param_mapping not initialised" unless @filter_param_mapping
    raise "#{filter_name} is not added to @filter_param_mapping" unless @filter_param_mapping.has_key?(filter_name)

    param_name = @filter_param_mapping[filter_name]
    if params[param_name]
      obj = true if ["true", "t","1","yes","y"].include?(params[param_name].strip)
      obj = false if ["false", "f","0","no","n"].include?(params[param_name].strip)
      instance_variable_set("@#{filter_name}", obj)
      @filters[filter_name] = obj if obj
    else
      if options[:default]
        obj = options[:default]
        instance_variable_set("@#{filter_name}", options[:default])
        @filters[filter_name] = options[:default]
      end
    end
  end

  # Use this method to create a filter if the value is in params as id
  # use parse_reference_filter(:brand, Brand)
  # use parse_reference_filter(:client, Client)
  # This will add 2 filters to @filters hash
  # if id of brand "toyota" is 1 and that of XYZ client is 2 it creates the following @filters
  # @filters = { brand: obj<"toyota">, client: obj<"XYZ"> }
  # parse_reference_filter_from_params(:b, :brand, Brand)
  def parse_reference_filter_from_params(filter_name, filter_class, **options)
    options.reverse_merge!(
      find_by_column: 'id'
    )

    raise "@filter_param_mapping not initialised" unless @filter_param_mapping
    raise "#{filter_name} is not added to @filter_param_mapping" unless @filter_param_mapping.has_key?(filter_name)

    param_name = @filter_param_mapping[filter_name]
    return unless params[param_name]

    if params[param_name].strip.downcase == "null"
      instance_variable_set("@#{filter_name}", "null")
      @filters[filter_name] = "null"
    else
      obj = filter_class.where(options[:find_by_column] => params[param_name].strip).first
      instance_variable_set("@#{filter_name}", obj)
      @filters[filter_name] = obj if obj
    end
  end

  def parse_from_and_to_year_filters(default_year: Date.today.year, last_how_many_years: 6)
    @to_year = @filters[:to_year] = params[:to_year] ? params[:to_year].to_i : default_year
    @from_year = @filters[:from_year] = params[:from_year] ? params[:from_year].to_i : (@to_year - last_how_many_years)
  end

end