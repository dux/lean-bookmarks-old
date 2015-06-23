module ApplicationHelper
  include RailsHelper
  include MasterHelper
  include FormHelper
  include TableHelper
  include SvgIcoModule

  def base_js
    ret = ['<script>']
    ret.push "window.DEV = #{Lux.dev? ? 'true' : 'false' };"
    ret.push "window.app = {}"

    if flash = (Lux.session[:flash] || Thread.current[:lux][:flash])
      ret.push "Info.#{flash[0]}(#{flash[1].to_json})"
      Lux.session.delete(:flash)
    end

    ret.push ['</script>']

    ret.join("\n").html_safe
  end

  def main_menu
    menu = Menu.new( :default=>!Lux.request.path.index('/users')  )

    if User.current
      # menu.add '/', 'Home'
      menu.add '/buckets', "#{svg_ico(:bucket)} Buckets", '/bucket'
      menu.add '/links',   "#{svg_ico(:link)} Links", '/link'
      menu.add '/notes',   "#{svg_ico(:note)} Notes", '/note'
    else
      menu.add '/', 'Home'
    end

    menu.active_by_path
    menu.render_li
  end

  def sub_menu
    menu = Menu.new

    if User.current
      menu.add '/users/bye', 'Log off'
      menu.add '/users/profile', "#{User.current.email.split('@')[0].trim(15)}@ #{svg_ico(:gear)}"
    else
      menu.add '/login', 'Login or signup'
    end

    menu.active_by_path
    menu.render_li
  end

  def narrow(width=500)
    data = capture do; yield; end
    %[<div class="row nudge"><div class="col-1"></div><div class="col-1" style="min-width:#{width}px;">#{data}</div><div class="col-1"></div></div>]
  end

end