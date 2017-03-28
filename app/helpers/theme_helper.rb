# This module creates Bootstrap wrappers around basic View Tags
module ThemeHelper
  # theme_fa_icon('plus')
  # <i class='fa fa-plus'></i>
  # theme_fa_icon('plus', 'lg')
  # <i class='fa fa-plus fa-lg'></i>
  def theme_fa_icon(icon_text, size="")
    size_class = %w{lg 2x 3x 4x 5x}.include?(size.strip) ? " fa-#{size.strip}" : ""
    "<i class='fa fa-#{icon_text}#{size_class}'></i>"
  end

  # theme_button_text('New Project')
  # <span class='btn-text'> New Project</span>
  def theme_button_text(text)
    "<span class='btn-text'> #{text}</span>"
  end

  # theme_button is used to create poodle like buttons which has built in classes and icons
  # e.g:
  #   theme_button('New Project', 'plus', new_admin_project_path)
  # The above is equivalent to
  #   link_to raw("<i class='fa fa-plus mr-10'></i><span class='btn-text'> New Project</span>"), new_admin_project_path, :class=>"btn btn-primary pull-right ml-5", :remote=>true
  # And produces the following html
  #   <a class="btn btn-primary pull-right ml-5" data-remote="true" href="/admin/projects/new"><i class="fa fa-plus mr-10"></i><span class="btn-text"> New Project</span></a>
  def theme_button(text, icon, url, options={})
    options.reverse_merge!(
      method: :get,
      remote: true,
      btn_type: :primary,
      btn_size: :md,
      classes: "pull-right ml-5 mb-5",
      data: {}
      )
    display_content = raw(theme_fa_icon(icon)+theme_button_text(text))
    link_to(display_content, url, :class=>"btn btn-#{options[:btn_type]} btn-#{options[:btn_size]} #{options[:classes]}", :remote=>options[:remote], method: options[:method], data: options[:data])
  end

  # Example
  #   theme_edit_button(edit_admin_project_path(@project))
  # is equivalent to:
  # ---------------------------
  # link_to raw("<i class=\"fa fa-edit mr-5\"></i> Edit"), edit_admin_project_path(@project), :class=>"btn btn-default btn-xs pull-right ml-10", :remote=>true %>
  def theme_edit_button(url, options={})
    options.reverse_merge!(
      text: "Edit",
      icon: "edit",
      method: :get,
      remote: true,
      btn_type: :default,
      btn_size: :xs,
      classes: "pull-right ml-10"
      )
    theme_button(options[:text], options[:icon], url, options)
  end

  # Example
  #   theme_delete_button(admin_project_path(@project))
  # is equivalent to:
  # ---------------------------
  # link_to raw("<i class=\"fa fa-trash \"></i> Delete"), admin_project_path(@project), method: :delete, data: { confirm: 'Are you sure?' }, :class=>"btn btn-danger btn-xs pull-right", :remote=>true
  def theme_delete_button(url, options={})
    options.reverse_merge!(
      text: "Delete",
      icon: "trash",
      method: :delete,
      remote: true,
      btn_type: :danger,
      btn_size: :xs,
      classes: "pull-right ml-10",
      data: { confirm: 'Are you sure?' }
      )
    theme_button(options[:text], options[:icon], url, options)
  end

  # theme_heading(heading)
  # theme_heading(heading, icon='cog')
  # <div class="row mb-10">
  #   <div class="fs-22 col-sm-12"><i class='fa fa-rub fa-lg mr-10'></i>Manage Projects</div>
  # </div>
  def theme_heading(heading, **options)
    options.reverse_merge!(
      icon: '',
      row_class: "",
      col_class: ""
    )
    content_tag :div, class: "row mb-10 #{options[:row_class]}" do
      content_tag :div, class: "fs-22 col-sm-12 #{options[:col_class]}" do
        raw((options[:icon].blank? ? '' : theme_fa_icon(options[:icon], 'lg')) + " #{heading}")
      end
    end
  end

  # theme_search_form is a helper to create a form to filter the results by entering a search query
  def theme_search_form(cls, url, method=:get, remote=true, text="", placeholder="Search ...", button_text="Search!", query_param_name="q")
    form_for cls.new, :url => url,
    :method => method, :remote=>remote,
    :html=>{:class=>"pull-right", :style=>"margin-bottom:0px;"} do |f|
      content_tag :div, class: "input-group" do
        text_field_tag(query_param_name,text, :class => 'form-control', :placeholder => placeholder) +
        content_tag(:span, class: "input-group-btn") do
          button_tag(type: 'submit', class: "btn btn-default") do
            raw(theme_fa_icon('search') +
              content_tag(:span, class: "btn-text") do
                " " + button_text
              end)
          end
        end
      end
    end
  end

  def theme_drop_down(collection, method_name, **options)
    options.reverse_merge!(
      text: "Click to View Items",
      scope: :admin
    )
    content_tag(:div, class: "btn-group mt-10 mb-10", style: "width:100%;") do
      button_tag(type: 'button', :class => "btn btn-default btn-block dropdown-toggle", "data-toggle" => "dropdown") do
        raw(options[:text] + content_tag(:span, "", class: "caret"))
      end +
      content_tag(:ul, class: "dropdown-menu", role: "menu") do
        li_array = []
        collection.each do |item|
          li_array << content_tag(:li) do
            url = main_app.url_for([options[:scope], item])
            link_to item.send(method_name), url, :remote => true
          end
        end
        raw(li_array.join(" ")) +
        content_tag(:li, link_to_next_page(collection, 'Next Page', :remote => true)) +
        content_tag(:li, link_to_previous_page(collection, 'Previous Page', :remote => true))
      end
    end
  end

  def clear_tag(height=nil)
    height_class = height ? " cl-#{height}" : ""
    content_tag(:div, "", class: "clearfix#{height_class}")
  end

  # Example
  #   theme_paginate(@projects)
  #
  # is equivalent to:
  # ---------------------------
  # <div class="cl"></div>
  # <% if @projects.any? %>
  #    <%= content_tag :div, :class=>"pull-right" do %>
  #      <%= paginate @projects, :remote => true %>
  #    <% end %>
  # <% end %>
  # <div class="cl"></div>
  # ---------------------------
  def theme_paginate(collection, remote=true)
    return "" if collection.empty?
    clear_tag(10) +
    content_tag(:div, :class=>"pull-right") do
      paginate(collection, :remote => remote)
    end +
    clear_tag(10)
  end

  # Example
  #   theme_panel_message("No Results found")
  #
  # is equivalent to:
  # ---------------------------
  #  <div class="panel panel-default text-color-grey p-80 text-align-center" style="height:200px;">
  #   "No Results found"
  #  </div>
  def theme_panel_message(message)
    content_tag(:div, class: "panel panel-default panel-message text-color-grey p-80 text-align-center", style: "height:200px;") do
      raw(message)
    end
  end

  # Example
  #   theme_panel_title("Team Members")
  #
  # is equivalent to:
  # ---------------------------
  #  <h3 class="panel-title">Team Members</h3>
  def theme_panel_title(title, classes="")
    content_tag(:h3, title, class: "panel-title #{classes}")
  end

  # Example
  #   theme_item_title(project.name, admin_project_path(project))
  #
  # is equivalent to:
  # ---------------------------
  #  <%= link_to project.name, admin_project_path(project), :remote=>true, :class=>"text-color-blue fs-16" %>
  def theme_item_title(title, url, classes = "text-color-blue fs-16", remote=true)
    link_to(title, url, :remote=>remote, :class=>classes)
  end

  # Example
  #   theme_item_sub_title(project.customer.name)
  #
  # is equivalent to:
  # ---------------------------
  #  <div class="text-color-red fs-14"><%= project.customer.name if project.customer %></div>
  def theme_item_sub_title(text, classes = "text-color-red fs-14")
    content_tag(:div, text, class: classes)
  end

  # Example
  #   theme_item_description(project.customer.name, 120)
  #
  # is equivalent to:
  # ---------------------------
  #  <div class="text-color-grey fs-12"><%= project.customer.description %></div>
  def theme_item_description(text, limit=120, classes = "text-color-grey fs-12")
    description = scrap_word(text, limit)
    content_tag(:div, description, class: classes)
  end

  def theme_detail_box(collection, **options)
    options.reverse_merge!(
      show_partial: "show",
      new_partial: "form",
      edit_partial: "form",
      index_partial: "show",
      )
    case params[:action]
    when "show"
      render partial: options[:show_partial]
    when "new"
      render partial: options[:new_partial]
    when "edit"
      render partial: options[:edit_partial]
    when "index"
      collection.empty? ? (theme_panel_message(I18n.translate("forms.no_results"))) : render(partial: options[:index_partial])
    else
      theme_panel_message(I18n.translate("forms.no_results"))
    end
  end

  # Example
  #   theme_more_widget(object, data_columns=[:id, :created_at, :updated_at], super_admin = true)
  # is equivalent to:
  # ---------------------------
  # <% if @current_user.is_super_admin? %>
  #  <%= render :partial => "widgets/more_details", :locals=>{
  #                        :data_model => @project,
  #                        :data_columns => [:id, :created_at, :updated_at],
  #                        :heading => "Technical Details",
  #                        :display_footer => false} %>
  # <% end %>
  def theme_more_widget(object, **options)
    options.reverse_merge!(
      data_columns: [:id, :created_at, :updated_at],
      super_admin: false,
      heading: "Technical Details"
      )
    display = options[:super_admin] ? @current_user.super_admin? : true
    render(:partial => "widgets/more_details",
      :locals=>{:data_model => object,
        :data_columns => options[:data_columns],
        :heading => options[:heading],
        :display_footer => false}) if display
  end

  # Example
  #   theme_panel_heading(@project.name)
  # is equivalent to:
  # ---------------------------
  # <div class="fs-24 text-color-green"><%= @project.name %></div>
  def theme_panel_heading(text, classes="fs-24 text-color-green")
    content_tag(:div, text, class: classes)
  end

  # Example
  #   theme_panel_sub_heading(@project.name, admin_customer_path(@project.customer))
  # is equivalent to:
  # ---------------------------
  # link_to(@project.customer.name, admin_customer_path(@project.customer), class: "fs-16 text-color-red")
  def theme_panel_sub_heading(text, url, classes="fs-16 text-color-red")
    link_to(text, url, class: classes)
  end

  # Example
  #   theme_panel_description(@project.pretty_url, "fs-14")
  #   theme_panel_description(@project.description, "fs-14 mt-10")
  # is equivalent to:
  # ---------------------------
  # <div class="fs-14"><%= @project.pretty_url %></div>
  # <div class="fs-14 mt-10"><%= @project.description %></div>
  def theme_panel_description(text, classes="fs-14")
    content_tag(:div, text, class: classes)
  end

  def drop_down_filter(text, items, **options)
    options.reverse_merge!(
      color: "default"
    )
    content_tag(:div, class: "btn-group") do
      content_tag(:button, text, class: "btn btn-#{options[:color]}", type: :button) +
      content_tag(:button, class: "btn btn-#{options[:color]} dropdown-toggle", type: :button, "data-toggle": "dropdown", "aria-haspopup": "true", "aria-expanded": "false") do
        content_tag(:span, "", class: "caret") + 
        content_tag(:span, "Toggle Dropdown", class: "sr-only")
      end +
      content_tag(:ul, class: "dropdown-menu") do
        items.collect {|item, link| concat(content_tag(:li, link_to(item, link)))}
      end
    end
  end

end