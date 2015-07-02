module PluginHelper
  include RailsHelper
  include MasterHelper
  include FormHelper

  def plugin_menu
    menu = Menu.new :default=>true
    menu.add Url.current.path('/plugin').relative, 'Link'
    menu.add Url.current.path('/plugin/domain').relative, 'Domain', '/plugin/domain'
    menu.add Url.current.path('/plugin/recent').relative, 'Recent', '/plugin/recent'
    menu.active_by_path
    menu.render_li
  end

end
