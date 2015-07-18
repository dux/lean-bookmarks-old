module MainHelper
  include RailsHelper
  include MasterHelper
  include FormHelper
  include TableHelper
  include SvgIcoModule

  def main_menu
    menu = Menu.new( :default=>!Lux.request.path.index('/users')  )

    if User.current
      # menu.add '/', 'Home'
      menu.add '/', svg_ico(:home), Proc.new { |path| path == '/' }
      menu.add '/buckets', "#{svg_ico(:bucket)} Buckets", '/bucket'
      menu.add '/links',   "#{svg_ico(:link)} Links", '/link'
      menu.add '/notes',   "#{svg_ico(:note)} Notes", '/note'
    else
      menu.add '/', 'Home'
    end

    menu.active_by_path
    menu.render_li.sub('>',' style="width:50px;">')
  end

  def sub_menu
    menu = Menu.new

    if User.current
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

  # def export(data)
  #   ret = []
  #   # id = Lux.uid
  #   # ret.push %[<script type="template/json" id="#{id}">#{data.to_json.sub(/^\s+/,'')}</script>]
  #   # ret.push %[<script>if (window.data === undefined) { window.data = {}; }
  #   #    window.data.#{name} = JSON.parse(document.getElementById('#{id}').innerHTML);
  #   #  </script>]
    
  #   for el in data
  #     ret.push %[<div class="w view-#{el.class.name.tableize.singularize}" style="display:none;">#{el.to_json.gsub(/\s+/,' ')}</div>] 
  #   end

  #   ret.join("\n")
  # end
end