module AdminHelper
  include FormHelper
  include RailsHelper
  include MasterHelper
  include TableHelper
  
  # = bs_form @user, :inline=>true, :horizontal=>false

  def short(date=nil)
    return unless date
    date.strftime("%Y-%m-%d")
  end

  def bs_set(title)
    %[<div class=""><div class="col-sm-3"></div><div class="col-sm-9"><h5>#{title}</h5></div></div>].html_safe
  end

  def bs_form(location, opts={}, &block)
    opts[:class] = 'form-horizontal' if opts.delete(:horizontal)
    @bs_horizontal = opts[:class] == 'form-horizontal' ? true : false
    @bs_inline = opts.delete(:inline) ? true : false
    @bs_object = location

    if location.kind_of?(String)
      @bs_object = nil
      if location[0,1] == '/'
        opts[:action] = location
      else
        opts['api-action'] = location
      end
    else
      opts['api-action'] = location.class.name.tableize+'/'
      opts['api-action'] += location.id ? "#{location.id}/update" : 'create'
    end

    data = capture(&block)
    opts.tag(:form, data)
  end

  def bs_input(name, opts={})
    label = opts.delete(:label) || name.to_s.capitalize.humanize
    hint  = opts.delete(:hint)

    # figure out default data type
    # if @bs_object
    #   opts = Input.fix_opts @bs_object, name, opts
    #   name = "#{@bs_object.class.name.downcase}[#{name}]"
    # end

    opts[:id] ||= Lux.uid
    
    if @bs_inline # only text can be in inline form
      opts[:class] ||= 'form-control'
      opts[:style] ||= ''
      opts[:style] += ';display:inline;'
      return Input.new(@bs_object).render(name, opts).html_safe
    end

    if opts[:as].to_s == 'checkbox'
      label = Input.new(@bs_object).render(name, opts) + label
      label += %[ <small class="gray">(#{hint})</small>] if hint
      ret = label.wrap('label')
      ret = ret.wrap('div', class:'checkbox')
      ret = ret.wrap('div', class:'col-sm-offset-3 col-sm-9') if @bs_horizontal
      ret = ret.wrap('div', class:'form-group') if @bs_horizontal
    else
      opts[:class] = 'form-control'
      ret =  label.wrap('label', :class=>@bs_horizontal ? 'col-sm-3 control-label' : nil)
      input = Input.new(@bs_object).render name, opts
      return input.html_safe if opts[:as] == :hidden
      input += hint.wrap('p', class:'help-block') if hint
      input = input.wrap('div', class:'col-sm-9') if @bs_horizontal
      ret += input
      ret =  ret.wrap('div', class:'form-group')
    end


    ret.html_safe
  end

  def bs_submit(name='Submit', url=nil, cancel=nil)
    ret = ''
    if @bs_object && @bs_object.id && @bs_object.can?(:write)
      delete = url ? "'#{url}'" : 'null'
      ret += %[<a class="btn btn-xs btn-danger" style="float:right;" onclick="Rails.delete('#{@bs_object.class.name.tableize}', #{@bs_object.id}, #{delete}); return false;">delete</a>]
    end
    ret += name.wrap('button', class:'btn btn-default', type:'submit' )
    ret += %[ &nbsp; or &nbsp; <a #{url[0,1]=='/' ? 'href="'+url+'"' : 'onclick="'+url+';return false;" href="#"' }>#{cancel || 'cancel'}</a>] if url
    ret = ret.wrap('div', class:'col-sm-offset-3 col-sm-9') if @bs_horizontal
    ret = ret.wrap('div', class:'form-group') if @bs_horizontal
    ret.html_safe
  end

  def bs_title(name)
    %[<div class="row"><div class="col-md-3"></div><div class="col-md-9"><h3>#{name}</h3></div></div>].html_safe
  end

  def bs_insert(data=nil)
    content_tag('div', :class=>'form-group') do
      ret = capture { block_given? ? yield : data.html_safe }
      %[<div class="col-sm-3"></div><div class="col-sm-9">#{ret}</div>].html_safe
    end
  end

  def bs_row(title, data=nil)
    content_tag('div', :class=>'form-group') do
      ret = capture { block_given? ? yield : data.html_safe }
      %[<label class="col-sm-3 control-label">#{title}</label><div class="col-sm-9">#{ret}</div>].html_safe
    end
  end

  def breadcrumb(*args)
    ret = []
    for el in args
      if el.kind_of?(Array)
        el = %[<a href="#{el[0]}">#{el[1]}</a>] 
      elsif el.respond_to?(:path)
        el = %[<a href="#{el.path}">#{el.name}</a>] 
      end
      ret.push el if el.present?
    end
    last = ret.pop
    ret = ret.map{ |el| %[<li>#{el} <span class="divider">/</span></li>] }.join("\n") + %[\n<li class="active"><b>#{last}</b></li>]
    ret.wrap('ul', :class=>:breadcrumb)
  end

  # = ul_menu Node.find_by_code('forum').children.sort
  # :param=>:id
  # :all=>['All categories', '/forums'] || :all=>'All categories'
  # :class=>'nav nav-tabs nav-stacked'
  # :path=>:path
  def bs_menu(list, opts={})
    full_path = '/'+request.path.split('/').drop(1).join('/')

    opts[:class] ||= 'nav nav-pills nav-stacked'
    ret = []
    if opts[:all]
      name,path = opts[:all].kind_of?(Array) ? opts[:all] : [opts[:all], request.path]
      list.unshift [path, name]
    end
    for el in list
      link = case el.class.name
        when 'String'
          'String NOT SUPPORTED'
        when 'Symbol'
          el.send(opts[:path])
        when 'Array'
          path = el[0]
          %[<a href="#{path}">#{el[1]}</a>]
        else
          path = opts[:param] ? %[?#{opts[:param]}=#{el.id}] : el.path
          %[<a href="#{path}">#{el.name}</a>]
      end

      # path.sub!(/admin2/,'admin')

      active = nil
      if opts[:param]
        active = true if params[opts[:param]].to_i == el.id
      end

      active = true if path && full_path == path
      active &&= %[ class="active"]

      count = opts[:count] ? %[<span style="float:right; color:#aaa; position:relative;top:3px;">#{opts[:count].to_s.capitalize.constantize.for(el).active.count}</span>] : ''
      ret.push %[<li#{active}>#{count}#{link}</li>]
    end
    ret = ret.join("\n")
    ret.sub!(/<li>/,'<li class="active">') unless ret =~ /"active"/
    ret = %[<ul class="#{opts[:class]}" style="#{opts[:style]}">#{ret}</ul>] unless opts[:ul].class.name == 'FalseClass'
    ret.html_safe
  end

  def bs_vertical(list, opts={})
    bs_menu(list, opts) 
  end

  def bs_tabs(list, opts={})
    opts[:class] = 'nav nav-tabs'
    bs_menu(list, opts)
  end

  def button_group(var, vals)
    m = SiteMenu::Auto.new :var=>var,
      :qs=>request.query_string,
      :template=>%[
        <div class="btn-group">
          {{#items}}<a class="btn{{#active}} btn-info{{/active}}" href="{{href}}">{{name}}</a>{{/items}}
        </div>]
    m.items vals
    m.render params[var]
  end

  def current_user
    User.current
  end

end