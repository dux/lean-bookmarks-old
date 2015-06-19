module ApplicationHelper
  include RailsHelper
  include MasterHelper
  include FormHelper
  include TableHelper

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
    menu = Menu.new
    menu.add '/', 'Home'
    menu.add '/users', 'Users', Proc.new { |path| path == '/users' || path.index('/user/') ? true : false }
    menu.add '/users/random', 'Random users'
    menu.active_by_path
    menu.render_li
  end

  def narrow(width=500)
    data = capture do; yield; end
    %[<div class="row nudge"><div class="col-1"></div><div class="col-1" style="min-width:#{width}px;">#{data}</div><div class="col-1"></div></div>]
  end

end