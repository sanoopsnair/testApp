class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include AuthenticationHelper
  include FlashHelper
  include NotificationHelper
  include UrlHelper

end
