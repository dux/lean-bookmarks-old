module MainHelper
  include RailsHelper
  include MasterHelper
  include FormHelper
  include TableHelper
  include SvgIcoModule

  def main_menu
    ret = []
    ret.push li(svg_ico(:home), '/', :style=>"width:50px;", :active=>Proc.new { |path| path == '/' })

    if User.current
      ret.push li("#{svg_ico(:bucket)} Buckets", '/bucket')
      ret.push li("#{svg_ico(:link)} Links", '/link')
      ret.push li("#{svg_ico(:note)} Notes", '/note')
    end

    ret.join('')
  end

  def sub_menu
    ret = []

    if User.current
      ret.push li("#{User.current.email.split('@')[0].trim(15)}@ #{svg_ico(:gear)}", '/users/profile')
    else
      ret.push li('Login or signup', '/login', :onclick=>"ga('send', 'event', 'ab', 'login-action', 'icon');")
    end

    ret.join('')
  end

  def narrow(width=500)
    data = capture do; yield; end
    %[<div class="row nudge"><div class="col-1"></div><div class="col-1" style="min-width:#{width}px;">#{data}</div><div class="col-1"></div></div>]
  end

  # li svg_ico(:home), '/', :style=>"width:50px;", :active=>Proc.new { |path| path == '/' })
  # li 'Links', '/link'
  def li(name, path, opts={})
    opts = { active:opts } unless opts.kind_of?(Hash)
    opts[:active] ||= path
    opts[:active] = request.path.start_with?(path) if opts[:active].kind_of?(String)
    opts[:class]='active' if true.resolve?(opts.delete(:active))
    opts.tag(:li, %[<a href="#{path}">#{name}</a>])
  end

  def link_thumb(link, opts={})
    if link[:thumbnail]
      opts[:onerror] = "this.src='#{link.thumbnail(true)}'"
      image_tag link[:thumbnail], opts
    else
      image_tag link.thumbnail, opts
    end
  end

  # def export(data)
  #   ret = []
  #   # id = Page.uid
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