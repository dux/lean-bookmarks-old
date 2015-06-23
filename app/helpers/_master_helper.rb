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

  def cache(*opts, &block)
    Cache.view *opts, &block
  end

end
