module BootstrapHelper

  # %ul.nav.navbar-nav
  #  = bs_top_menu [["Users", @bucket.path], ['Triggered', @bucket.path(:campaigns), 'campaigns'], ['Messages', @bucket.path(:messages), 'messages'], ['Newsletters', @bucket.path(:newsletters),'news']]
  def bs_top_menu(items)
    ret = []

    we_have_active = false
    for el in items.reverse
      next if el[1] =~ /javascript:/
      el[2] ||= ''
      if el[1] != '/' && request.path.index(el[2]) && ! we_have_active
        we_have_active = true
        el[2] = true
      else
        el[2] = false
      end
    end

    items[0][2] = true unless we_have_active

    for name, path, active in items
      klass = active ? %[ class="active"] : ''
      link = path =~ /javascript:/ ? %[onclick="#{path.split(':')[1]}"] : %[href="#{path}"]
      ret.push %[<li#{klass}><a #{link}>#{name}</a></li>]
    end

    ret.join("\n").html_safe
  end
  
  # = bs_select :onclick=>%[$('#spf').val(value)], :data=>[['Action','1'], ['Anothrt action','111'], [], ['After separator', 3]], :input=>{ :name=>:miki, :id=>'spf' }, :style=>"width:300px;", :name=>'Field?'
  def bs_select_helper(opts={})
    if input = opts[:input]
      input[:type] ||= 'text'
      input[:class] ||= 'form-control'
      @input = input.tag :input
    end

    ret = []
    ret.push %[<div class="input-group" style="#{opts[:style]}"><div class="input-group-btn">]
    ret.push %[<button class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">#{opts[:name] || 'Action'}<span class="caret"></span></button>]
    ret.push %[<ul class="dropdown-menu" role="menu">]
    for key,val in opts[:data]
      ret.push val ? %[<li><a onclick="value='#{val}'; #{opts[:onclick].gsub(/"/,'&quot;')}">#{key}</a></li>] : %[<li class="divider"></li>]
    end
    ret.push '</ul>'
    ret.push '</div>'

    ret.push @input

    ret.push '</div>'
    ret.join('').html_safe
  end  

  # = bs_button_group params[:sort], [['Broju računa', request.path], ['Nazivu tvrtke', "#{request.path}?sort=c", 'c']]
  def bs_button_group(var, vals)
    have_active = false
    vals.map do |el|
      next unless el[2] == var
      have_active = true 
      el[3] = true
    end

    vals[0][3] = true unless have_active
    ret = ['<div class="btn-group">']
    for el in vals
      klass = el[3] ? ' btn-info' : ' btn-default'
      ret.push %[<a class="btn#{klass}" href="#{el[1]}">#{el[0]}</a>]
    end
    ret.push '</div>'
    ret.join('').html_safe
  end

  def bs_breadcrumb(*args)
    ret = []
    for el in args
      if el.kind_of?(Array)
        el = %[<a href="#{el[1]}">#{el[0]}</a>] 
      elsif el.respond_to?(:path)
        el = %[<a href="#{el.path}">#{el.name}</a>] 
      end
      ret.push el if el.present?
    end
    last = ret.pop
    ret = ret.map{ |el| %[<li>#{el} <span class="divider"></span></li>] }.join("\n") + %[\n<li class="active"><b>#{last}</b></li>]
    ret.wrap('ul', :class=>:breadcrumb)
  end

  def bs_info(data=nil, ico=nil)
    data ||= capture do; yield; end
    ico = svg_ico(ico, 64, '#428BCA')+%[<br /><br />].html_safe if ico
    %[<div class="alert alert-info" style="text-align:center; padding:30px; font-size:14pt;">#{ico}#{data}</div>].html_safe
  end

  def bs_main_nav
    items = []
    if User.current
      items.push ['Issues', '/']
      items.push ['Clients', '/clients', 'clients']
    else
      items.push ['About', '/']
      items.push ['Login & signup', '/login', 'login']
    end
    bs_top_menu items
  end

end