module FlashHelper
  # This function will set a flash message depending up on the request type (ajax - xml http or direct http)
  # Example
  #   set_flash_message("The message has been sent successfully", :success, false)
  #   set_flash_message("Permission denied", :error)
  #
  # Difference between flash and flash.now
  # http://trace.adityalesmana.com/2010/10/difference-between-flash-and-flash-now-in-ruby/
  def set_flash_message(message, type, now=true)
    if now
      flash.now[type] = message
    else
      flash[type] = message
    end
  end

  # Example
  # ajax_notice = get_flash_message(true)
  # notice = get_flash_message(false)
  def get_flash_message(now=true)
    if now
      message = flash.now[:success] || flash.now[:notice] || flash.now[:alert] || flash.now[:error]
    else
      message = flash[:success] || flash[:notice] || flash[:alert] || flash[:error]
    end
    message
  end

  # Example
  # <div id="div_flash_message">
  #   <%= flash_message() -%>
  # </div>
  def flash_message(now=true)
    message = get_flash_message(now)
    cls_name = "alert-info"
    cls_name = 'alert-success' if flash.now[:success] || flash[:success]
    cls_name = 'alert-warning' if flash.now[:alert] || flash[:alert]
    cls_name = 'alert-danger' if flash.now[:error] || flash[:error]

    message = message.strip if message

    content_tag(:div, class: "alert #{cls_name} fade in mb-10", "data-alert" => "alert") do
      raw(link_to("×", "#", class: "close", "data-dismiss" => "alert") + content_tag(:p, message))
    end unless message.blank?
  end
end
