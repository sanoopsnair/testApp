module ParamsParserHelper
  def parse_pagination_params
    @current_page = params[:page] || "1"
    @per_page = params[:per_page] || ConfigCenter::Defaults::ITEMS_PER_LIST.to_s

    if @per_page && @per_page.to_i > ConfigCenter::Defaults::MAX_ITEMS_PER_LIST
      @per_page = ConfigCenter::Defaults::ITEMS_PER_LIST.to_s
    end

    @offset = (@current_page.to_i - 1) * (@per_page.to_i)

  end

  def parse_filter_dates(instance_name, start_date_name="start_date", end_date_name="end_date")
    ## Parsing the date info if any
    unless params[instance_name][start_date_name].blank?
     d = params[instance_name][start_date_name] ? (Time.parse(params[instance_name][start_date_name])) : (Date.today - 1.day)
     @start_date = params[instance_name][:start_date] || (Date.today - 1.day)
     @start_time = Time.utc(d.year,d.month,d.day,00,00,00)
    end
    unless params[instance_name][end_date_name].blank?
     d = params[instance_name][end_date_name] ? Time.parse(params[instance_name][end_date_name]) : Date.today
     @end_date = params[instance_name][end_date_name] || Date.today
     @end_time = Time.utc(d.year,d.month,d.day,23,59,59)
    end
  end
end


