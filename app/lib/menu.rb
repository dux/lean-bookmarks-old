# menu = Menu.new
# menu.add '/', 'Home'
# menu.add '/users', 'Users', lambda { |path| ['/users','/user'].index(path) }
# menu.add '/users/random', 'Random users'
# menu.active_by_path
# menu.render

class Menu

  def initialize
    @menu = []
  end

  def add(href, name, check=nil)
    @menu.push({ href:href, name:name, check:check })
  end

  def active_by_path
    path = Lux.request.path
    for el in @menu
      break if @we_have_active
      if el[:check]
        if el[:check].call(path)
          el[:active] = @we_have_active = true
        end
      elsif el[:href] == path
        el[:active] = @we_have_active = true
      end
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