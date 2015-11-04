module MasterHelper

  def sfor(list, if_empty=false, &block) # umjesto for, safe for koji ne razbije app nego lijepo prijavi error
    if !list || (list.empty? && if_empty)
      concat %[<div class="alert alert-info" style="width:97%;">#{if_empty}</div>].html_safe
      return
    end
    for el in list
      begin
        yield(el)
      rescue
        concat(%[<pre style="background-color:#fdd; padding:4px; border:1px solid #ccc;"><ul><li>Object: #{}#{el.as_link rescue '-'} (#{el.class.name})</li><li>Error: #{$!}</li></ul></pre>])
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

  def base_js
    ret = ['<script>']
    ret.push "window.DEV = #{Page.dev? ? 'true' : 'false' };"
    ret.push "window.app = {}"

    if flash = (Page.session[:flash] || Thread.current[:lux][:flash])
      ret.push "Info.#{flash[0]}(#{flash[1].to_json})"
      Page.session.delete(:flash)
    end

    ret.push ['</script>']

    ret.join("\n").html_safe
  end

  def labels(list, base_path=nil)
    return unless list

    ret = list.map do |el|
      tag = el.try(:name) || el
      url = case base_path.class.name
        when 'Proc'; base_path.call(tag)
        when 'String'; "#{base_path}?tag=#{tag}"
        else; App.url(tag:(tag))
      end
      name = el.kind_of?(String) ? el : el.name
      %[<a class="label label-#{params[:tag] == name ? :primary : :default} tag" href="#{url}">#{el.kind_of?(String) ? el : "#{el.name} (#{el.cnt})"}</a>]
    end.join(' ').html_safe

    %[<p class="tags">#{ret}</p>].html_safe
  end

  def template(render_template, list)
    data = list.map{ |el| el.respond_to?(:data) ? el.data : el.attributes }
    %[<div id="#{render_template}"></div><script>
      if (! window.DATA) { window.DATA = {}; }
      window.DATA['#{render_template}'] = #{data.to_json};
      Template.render('#{render_template}');
    </script>]
  end

end
