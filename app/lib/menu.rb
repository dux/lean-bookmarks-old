# menu = Menu.new
# menu.add '/', 'Home'
# menu.add '/users', 'Users'
# menu.add '/users/random', 'Random users'
# menu.active_by_path
# menu.render

class Menu

  def initialize
    @menu = []
  end

  def add(link, name, active=nil)
    @menu.push({ href:link, name:name })
  end

  def active_by_path
    path = Lux.request.path
    for el in @menu
      el[:active] = @we_have_active = true if el[:href] == path
    end
  end

  def render_li
    @menu[0][:active] = true unless @we_have_active
    
    ret = []

    for el in @menu
      active = el[:active] ? ' class="active"' : ''
      ret.push %[<li#{active}><a href="#{el[:href]}">#{el[:name]}</a></li>]
    end
    
    ret.join('')
  end

end