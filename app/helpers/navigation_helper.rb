module NavigationHelper
  def nav_active?(name)
    @nav == name
  end

  def nav_class(name)
    nav_active?(name) ? "active" : ""
  end

  def set_nav(name)
    @nav = name
  end

  def current_nav
    @nav
  end
end
