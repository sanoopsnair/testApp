module NotificationHelper
  def set_notification_messages(id, alert_type, now_type=false)
    @heading = I18n.t("#{id}.heading")
    @message = I18n.t("#{id}.message")
    @alert ||= "#{@heading}: #{@message}"
    @alert_type = alert_type
    set_flash_message(@alert, alert_type, now_type) if defined?(flash) && flash
  end
end