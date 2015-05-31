class Header

  def initialize(title)
    @title = title
    @meta = {}
    @data = []
    @render_start ||= Time.new
  end

  def self.js(*path)
    path.map{ |el| Helper.javascript_include_tag el }.join("\n")
  end

  def self.css(*path)
    path.map{ |el| Helper.stylesheet_link_tag el }.join("\n")
  end

  def asset_path(name, type)
    return name if Rails.env.development?
    
    return name if name =~ /:/

    return 'https://code.jquery.com/jquery-2.1.1.min.js' if name.to_s == 'jquery2'
    return 'https://code.jquery.com/ui/1.11.0/jquery-ui.min.js' if name.to_s == 'jquery-ui'

    unless man = Thread.current[:manifest]
      manifest = Dir["#{Rails.root}/public/assets/manifest*.json"].first
      return 'NO MANIFEST FILE FOR SPROCKETS' unless manifest
      # File.read((manifest) 
      data = JSON File.read(manifest) 
      Thread.current[:manifest] = man = data['assets']
    end

    path = man["#{name}/index.#{type}"] || man["#{name}.#{type}"]
    path = "/assets/#{path}" if path
    return path if path

    r "Header assets: [#{name}.#{type}] not found in compiled assets."
  end

  def component(name, type=:all)
    if name.kind_of?(String)
      @data.push Helper.javascript_include_tag(name) if name =~ /\.js/
      @data.push Helper.stylesheet_link_tag(name) if name =~ /\.css/
    else
      @data.push Helper.stylesheet_link_tag(asset_path(name, :css)) if [:all, :css].index(type)
      @data.push Helper.javascript_include_tag(asset_path(name, :js)) if [:all, :js].index(type)
    end
  end

  def meta(name, data)
    @meta[name.to_s] = data
  end

  def js(path)
    path = asset_path(path, :js)
    @data.push Helper.javascript_include_tag path
  end

  def css(path)
    @data.push Helper.stylesheet_link_tag path
  end

  def icon(icon='/favicon.png', size=nil)
    if icon =~ /\.png/
      @data.unshift %[<link href="#{icon}" rel="shortcut icon" type="image/vnd.microsoft.icon" /><link href="#{icon}" rel="apple-touch-icon" type="apple" />]
    else
      @data.unshift size ? %{<link rel="icon" href="#{icon}" sizes="#{size}x#{size}" />} : %{<link rel="shortcut icon" href="#{icon}" type="image/x-icon" />}
    end
  end

  def render(title=nil)
    title ||= 'Home'
    title.gsub!(/<[^>]+>/,'')
    title += " | #{@title}"
    
    speed = "#{((Time.now-@render_start)*1000).to_i}ms"
    meta 'debug:render_time', speed

    title = "#{speed} #{title}" if Rails.env.development?

    meta :viewport, 'width=device-width,initial-scale=1'
    meta :keywords, @keywords if @keywords.present?
    meta :description, @description.trim(155) if @description.present?

    for k, v in @meta
      @data.push %[<meta name=”#{k}” content="#{v.trim(155).gsub(/"/,'&qout;')}" />]
    end

    h_head = []
    h_link = []
    h_script = []

    for el in @data
      if el =~ /<link|<title/
        h_link.push(el)
      elsif el =~ /<script/
        h_script.push(el)
      else
        h_head.push(el)
      end
    end

    ret_arr = [h_head, h_link, h_script].flatten
    # ret_arr.unshift (%{<link rel="canonical" href="#{@canonical}" />}) if @canonical
    ret_arr.unshift  %{<title>#{title}</title>}
    ret_arr.unshift %{<meta http-equiv="Content-type" content="text/html; charset=#{@charset}" />}
    ret = ret_arr.join "\n"
    ret.gsub!(/(=\w+)\.js"/,'\1"') # google hack za http://maps.google.com/maps/api/js?sensor=true.js
    ret
  end
end