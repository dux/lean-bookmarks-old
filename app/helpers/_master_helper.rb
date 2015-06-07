module MasterHelper

  def widget(path, obj={})
    unless path.kind_of?(String)
      cname = path.class.name.tableize
      obj[:_id] ||= "w-#{cname.singularize}-#{path.id}"
      obj[cname.singularize.to_sym] = path
      path = "/#{cname}/#{cname.singularize}"
    end

    id = obj.delete(:_id)

    par = {}
    for k,v in obj
      unless ['String', 'Integer', 'Symbol', 'Fixnum', 'TrueClass', 'FalseClass'].index(v.class.name)
        v = 'o:'+Crypt.encrypt("#{v.class.name}:#{v.id}")
      end
      par[k] = v
    end

    id = id ? %[id="#{id}"] : ''

    ret = render path, obj
    %[<widget #{id} url="/part#{path}?#{par.to_url_params}">#{ret.chomp}</widget>].html_safe
  end

  def sfor(list, if_empty=false, &block) # umjesto for, safe for koji ne razbije app nego lijepo prijavi error
    if !list || (list.empty? && if_empty)
      concat %[<div class="alert alert-info" style="width:97%;">#{if_empty}</div>].html_safe
      return
    end
    for el in list
      begin
        yield(el)
      rescue
        concat(raw %[<pre style="background-color:#fdd; padding:4px; border:1px solid #ccc;"><ul><li>Object: #{}#{el.as_link rescue '-'} (#{el.class.name})</li><li>Error: #{$!}</li></ul></pre>])
      end
    end
  end

  # cols 2, 'col-md-6', @buckets do
  def cols(num, list, &block)
    elms = []
    cnt = 0
    for el in list
      data = capture { block.call(el) }
      next unless data =~ /\w/
      pos = cnt%num
      elms[pos] ||= []
      elms[pos].push data
      cnt += 1
    end
    ret = ['<div class="row">']
    for el in elms
      ret << %[<div class="col-1">#{el.join('')}</div>]
    end
    ret << '</div>'
    ret.join('').html_safe
  end

  def cache(*opts, &block)
    Cache.view *opts, &block
  end

  def once(rule, &block)
    @Once_Hash ||= {}
    return if @Once_Hash[rule]
    @Once_Hash[rule] = true
    yield
  end

  def once_reset
    @Once_Hash = {}
  end

end
