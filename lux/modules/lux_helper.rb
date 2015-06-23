class LuxHelper

  def capture(&block)
    capture_haml(&block)
  end

  def params
    Lux.params
  end

  def request
    Lux.sinatra.request
  end

  # renders just template but it is called 
  # = render :_link, link:link
  # = render 'main/links/_link', link:link
  def render(name, opts={}, &block)
    name = name.to_s
    name = "#{Template.last_template_path}/#{name}" unless name.index('/')

    if block_given?
      name = "#{name}/layout" unless name.index('/')
      local_data = capture(&block)
      Template.new(name).part(instance_variables_hash) do
        local_data
      end
    else
      Template.new(name).part(instance_variables_hash.merge(opts))
    end
  end

  def cell(name, action, *args)
    klass = Template.last_template_path.split('/')[1].classify
    "#{klass}::#{name.to_s.classify}Cell".constantize.part(action, *args)
  end

  def paginate(list)
    return if list.empty?

    ret = ['<div class="paginate"><div>']

    unless list.respond_to?(:paginate_page)
      return Lux.error('Paginate recieved list but it is not paginated in model scope. ')
    end

    if list.paginate_page > 0
      url = Url.current
      list.paginate_page == 1 ? url.delete(list.paginate_var) : url.qs(list.paginate_var, list.paginate_page)
      ret.push %[<a href="#{url.relative}">&larr;</a>]
    else
      ret.push %[<span>&larr;</span>]
    end

    ret.push %[<i>#{list.paginate_page == 0 ? '&bull;' : list.paginate_page+1}</i>]

    if list.paginate_per_page == list.length
      url = Url.current
      url.qs(list.paginate_var, list.paginate_page+2)
      ret.push %[<a href="#{url.relative}">&rarr;</a>]
    else
      ret.push %[<span>&rarr;</span>]
    end

    ret.push '</div></div>'
    ret.join('')
  end
end

