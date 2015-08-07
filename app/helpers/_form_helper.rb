# = form User.new, :template=>[:table, { :class=>:table, :width=>130 }] do
#   = input :name
#   = input :data, :as=>:textarea
#   = input :test, :as=>:checkbox
#   = input :sel, :as=>:select, :collection=>[1,2,3,4], :style=>"width:100px;"
#   = submit 'Save'

module FormHelper

  def form(location=nil, opts={}, &block)
    if location.kind_of?(Hash)
      opts = location.dup
      location = nil
    end
    
    opts = { :template=>opts } if opts.kind_of?(Symbol)
    opts[:method] = 'get' if opts.delete(:get)
    opts[:method] ||= 'get' unless location
    opts[:method] ||= 'post'
    opts[:opts] ||= {} # inner opts, as for templete table

    if opts[:template].kind_of?(Array)
      opts[:opts] = opts[:template][1]
      opts[:template] = opts[:template][0]
    end

    @form_template = (opts.delete(:template) || :inline).to_s[0,3]
    @form_opts = opts
    @form_object = nil

    location ||= Lux.sinatra.request.path
    if location.kind_of?(String)
      if location.sub!(/\/api\//,'')
        opts['api-action'] = location
      else
        opts[:action] = location
      end        
    else
      @form_object = location
      opts['api-action'] = location.class.name.tableize+'/'
      opts['api-action'] += location.id ? "#{location.id}/update" : 'create'
    end

    data = ''

    opts[:onsubmit] ||= "Api.post('/api/#{opts.delete('api-action')}', { form:this, params:$(this).serializeHash(), done:function(){ #{opts.delete(:done)}; }}); return false;"
    @form = FormTemplate.create(@form_template, @form_object, opts)
    
    # copy some fields for new objects, experimental
    if @form_object && ! @form_object.attributes[:id]
      for k,v in @form_object.attributes
        next unless k =~ /_id$/ || ['grp_id','grp_type'].index(k)
        next unless v.present?
        cname = @form_object.class.name.tableize.singularize
        data += capture do; %[<input type="hidden" name="#{cname}[#{k}]" value="#{v}" />]; end        
      end
    end

    data = capture_haml(&block)
    # eval "data += yield.to_s"
    data = @form.wrap data
    
    ret = @form_opts.slice('api-action', :class, :id, :style, :done, :action, :method, :onblur, :onsubmit).tag :form, data.html.gsub(/&quot;/,'"')
    ret.html
  end

  def input(name, opts={})
    # if we give plain object, treat is as link object
    unless ['Symbol', 'String'].index(name.class.name)
      oname = name.class.name.tableize.singularize
      fname  = @form_object.class.name.tableize.singularize
      if @form_object && @form_object.respond_to?("#{oname}_id") # grp
        return %[<input type="hidden" name="#{fname}[#{oname}_id]" value="#{name.id}" />]
      else
        return  %[<input type="hidden" name="#{fname}[grp_id]" value="#{name.id}" /><input type="hidden" name="#{fname}[grp_type]" value="#{name.class.name}" />]
      end
    end

    # auto fill value for GET forms
    @form_opts ||= {}
    opts[:value] ||= Lux.params[name] if @form_opts[:method] == 'get'

    return Input.new(@form_object).render(name, opts).html_safe if opts[:as] == :hidden || !@form

    label = opts.delete(:label) || name.to_s.humanize
    @form.row name, opts, label
  end

  def submit(name, opts={}, &block)
    opts[:extra] = capture do; yield; end if block_given?
    @form.submit name, opts
  end
end

class FormTemplate

  def self.create(template, obj, opts)
    eval "FormTemplate#{template.to_s.capitalize}.new(obj, opts)"
  end

  def initialize(obj, opts)
    @object = obj
    @opts = opts
    prepare
  end

  def prepare
  end

  def wrap(data)
    data
  end

  def row(name, opts, label)
    # if input attribute is present use it as ready string input object. used for passing submit buttons to rows
    (opts[:input] || Input.new(@object).render(name, opts).html_safe)
  end

  def submit(name, opts={})
    extra = opts.delete(:extra)
    opts[:input] = opts.tag :button, name
    opts[:input] += " #{extra}" if extra
    row nil, opts, ''
  end

end

class FormTemplateInl < FormTemplate 
  def row(name, opts, label)
    opts[:class] = "#{opts[:class]} form-control"
    opts[:style] = "max-width:200px; display:inline; #{opts[:style]}"
    super
  end

  def submit(name, opts={})
    opts[:class] ||= "btn btn-default btn-primary"
    opts[:style] = "#{opts[:style]}; position:relative; top:-1px;"
    super
  end
end

#horizontal
class FormTemplateHor < FormTemplate
  def wrap(data)
    %[<div class="form-horizontal">#{data}</div>]
  end

  def prepare
    @opts[:class] = 'form-horizontal'
  end

  def row(name, opts, label)
    opts[:class] = "#{opts[:class]} form-control" if opts[:as] != :checkbox
    opts[:id] ||= Lux.uid
    input = opts[:input] || Input.new(@object).render(name, opts.dup)
    hint = opts[:hint]
    # if opts[:as] == :checkbox
    #   hint &&= " (#{hint})"
    #   return %[<div class="form-group type-checkbox">
    #     <div class="checkbox"><label>#{input}#{label}<small>#{hint}</small></label></div>
    #   </div>]
    # end

    %[<div class="form-group type-#{opts[:as].or(:string)}">
      <label class="col-sm-3 control-label" for="#{opts[:id]}">#{label}</label>
      <div class="col-sm-9">#{input}<small>#{hint}</small></div>
    </div>]
  end

  def submit(name, opts={})
    opts[:class] ||= "btn btn-default btn-primary"
    super
  end
end

#vertical
class FormTemplateVer < FormTemplate
  def wrap(data)
    %[<div class="form-vertical">#{data}</div>]
  end

  def row(name, opts, label)
    opts[:class] = "#{opts[:class]} form-control" if opts[:as] != :checkbox
    opts[:id] ||= Lux.uid
    input = opts[:input] || Input.new(@object).render(name, opts.dup)
    hint = opts[:hint]
    # if opts[:as] == :checkbox
    #   hint &&= " <small>(#{hint})</small>"
    #   return %[<div class="form-group"><div class="checkbox"><label for="#{opts[:id]}">#{input} #{label}<small>#{hint}</small></label></div></div>]
    # end

    %[<div class="form-group type-#{opts[:as]}"><label for="#{opts[:id]}">#{label}</label>#{input}<small>#{hint}</small></div>]
  end

  def submit(name, opts={})
    opts[:class] ||= "btn btn-md btn-primary"
    super
  end
end

#table
class FormTemplateTab < FormTemplate
  def wrap(data)
    %[<table class="form-table"><col width="#{@opts[:opts][:width] || 150}" />#{data}</table>]
  end

  def row(name, opts, label)
    opts[:class] = "#{opts[:class]} form-control"
    opts[:id] ||= Lux.uid
    input = opts[:input] || Input.new(@object).render(name, opts)
    %[<tr><td><label for="#{opts[:id]}">#{label}</label></td><td>#{input}</td></tr>]
  end

  def submit(name, opts={})
    opts[:class] ||= "btn btn-default btn-primary"
    super
  end
  
end
