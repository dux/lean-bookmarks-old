#MasterApp 
# :get    - automatic render routing to render(:index) or render(:show)
# :part   - render only part without layout
# :render - render part with layout
#
# in instance methods
# template :name - render template (render in rails)
# render :name, *opts - render full template
# part :name, *opts - render part withot layout


class LuxCell
  # /           - empty route is self.render(:index)
  # /5          - Numeric is self.render(:show, 5) or show!(5)
  # /random
  #   - is new.random!() if  cell has method "random!" (useful if you dont want to render template)
  #   - is render(:random) if  cell has method "random"
  # /5/comments - is self.render(:comments, 5) or is comments!(5)
  def self.resolve(*args)
    local_args = args.kind_of?(Array) ? args.flatten.dup : [args]

    local_args[0] = local_args[0].to_s if local_args[0].kind_of?(Symbol)

    if !local_args[0]
      local_args[0] = :index
    elsif local_args[1]
      local_args = local_args.reverse
    elsif local_args[0].to_i.to_s == local_args[0].to_s
      local_args.unshift(:show)
    end

    obj = new

    return render(*local_args) if obj.respond_to?(local_args[0])

    local_args[0] = "#{local_args[0]}!"
    return obj.send(*local_args) if obj.respond_to?(local_args[0])


    list = self.instance_methods - Object.instance_methods - [:render, :render_part, :_find_template_path, :template, :template_part]

    err = ["No instance method <b>#{local_args[0].sub('!','')}</b> nor <b>#{local_args[0]}</b> found in class <b>#{self.name}</b>"]
    err.push ["Expected so see def show(id) ..."] if local_args[0] == 'show!'
    err.push %[You have defined \n- #{(list).join("\n- ")}]
    return Lux.error(err)
  end

  def self.part(*args)
    _part(*args)[0]
  end

  def self._part(*args)
    copy = args.dup
    method_name = copy.shift
    obj = new
    obj.send(method_name, *copy)
    @local_path = obj.class.name.index('::') ? obj.class.name.sub(/Cell$/,'').tableize : obj.class.name.sub(/Cell$/,'').downcase
    @local_path += "/#{method_name}"
    data = Lux.try 'Temmplate error' do
      Template.new(@local_path).part( obj.instance_variables_hash )
    end
    [data, obj.instance_variables_hash]
  end

  def self.render(*args)
    # look for before methods
    if @@before[self.name]
      for el in @@before[self.name]
        before_data = el.call
        return before_data if before_data.kind_of?(String)
      end
    end

    @part_data, hash = *_part(*args)
    layout_path = get_layout_path
    Template.new(layout_path).part(hash) do
      @part_data
    end
  end

  @@layout = {}
  def self.layout(what)
    @@layout[self.name] = what
  end

  def self.get_layout_path
    if l = @@layout[self.name]
      l = "#{l}/layout" if l.kind_of?(Symbol)
      l = l.call if l.kind_of?(Proc)
      return l
    else
      return "#{@local_path.split('/')[0]}/layout"
    end
  end

  def self.template(*args)
    for el in args
      define_method el do
        true
      end
    end
  end

  @@before = {}
  def self.before(&block)
    @@before[self.name] = []
    @@before[self.name].push(block)
  end

  # def _find_template_path(path)
  #   return path if path.to_s.index('/')
  #   "#{self.class.name.tableize.split('_cell')[0].pluralize}/#{path}"
  # end

  # # inside instance method when you want to render specific template
  # def template(template=nil)
  #   # template is second part part unless defined.
  #   # for path /action/confirm_email -> template is "confirm_email"
  #   template ||= Lux.sinatra.request.path.split('/')[2]
    
  #   path = _find_template_path(template)
  #   Template.new(path).render( instance_variables_hash )
  # end

  # # inside instance method when you want to render specific template part
  # def template_part(template)
  #   path = _find_template_path(template)
  #   Template.new(path).part( instance_variables_hash )
  # end

  # # inside instance method when you want to class render method
  # render(:show, id)
  def render(name, *args)
    self.class.render(name, *args)
  end

end

