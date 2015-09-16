class LuxHelper

  def capture(&block)
    capture_haml(&block)
  end

  def params
    Page.params
  end

  def request
    Page.sinatra.request
  end

  # renders just template but it is called 
  # = render :_link, link:link
  # = render 'main/links/_link', link:link
  def render(name, opts={}, &block)
    
    # render @link
    if name.respond_to?(:created_by)
      path = Template.last_template_path.split('/')[1]
      eval "@#{name.class.name.tableize.singularize} = name"
      name = "#{path}/#{name.class.name.tableize}/_#{name.class.name.downcase}"
    else
      name = name.to_s
      name = "#{Template.last_template_path}/#{name}" unless name.index('/')
    end

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
    unless list.respond_to?(:paginate_page)
      return Error.server('Paginate recieved list but it is not paginated in model scope. ')
    end

    if list.paginate_page == 0
      return if list.empty?
      return if list.paginate_per_page > list.length
    end

    ret = ['<div class="paginate"><div>']

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

  def cache(in_key, ttl=nil, &block)
    key = nil

    if in_key.kind_of?(Array)
      # = cache ['buckets', User.current.id, @buckets.first] do
      ret = []
      for el in in_key
        if el.respond_to? :updated_at
          ret.push "#{el.class.name}-#{el.id}-#{el.updated_at.to_i}"
        elsif el.kind_of? Symbol
          ret.push el.to_s
        elsif el.respond_to? :id
          ret.push "#{el.class.name}:#{el.id}" rescue ''
        else
          ret.push el.to_s rescue 'nil'
        end
      end
      key = ret.join('-')
    else
      # = cache 'buckets' do
      key = in_key
    end

    Cache.fetch key, ttl do
      capture(&block)
    end
  end
end

