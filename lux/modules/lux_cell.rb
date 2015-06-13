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
  def self.raw(args)
    local_args = args.kind_of?(Array) ? args.flatten.dup : [args]
 
    if !local_args[0]
      local_args[0] = :index
    elsif local_args[1]
      local_args = local_args.reverse
    elsif local_args[0].to_i.to_s == local_args[0].to_s
      local_args.unshift(:show)
    end

    obj = new

    return render(*local_args) if obj.respond_to?(local_args[0])

    local_args[0] += '!'

    unless obj.respond_to?(local_args[0])
      list = self.instance_methods - Object.instance_methods - [:render, :render_part, :params, :request]

      err = ["No instance method <b>#{local_args[0].sub('!','')}</b> nor <b>#{local_args[0]}</b> in class <b>#{self.name}</b>"]
      err.push %[You have defined \n- #{(list).join("\n- ")}]
      return Lux.error(err)
    end

    return obj.send(*local_args)
  end

  def self.part(*args)
    copy = args.dup
    method_name = copy.shift
    obj = new
    obj.send(method_name, *copy)
    @local_path = obj.class.name.index('::') ? obj.class.name.sub(/Cell$/,'').tableize : obj.class.name.sub(/Cell$/,'').downcase
    @local_path += "/#{method_name}"
    Template.new(@local_path).part( obj.instance_variables_hash )
  end

  def self.render(*args)
    @part_data = part(*args)
    layout_path = "#{@local_path.split('/')[0]}/layout"
    Template.new(layout_path).part do
      @part_data
    end
  end

  def sinatra
    Lux.sinatra
  end

  def _find_template_path(path)
    return path if path.to_s.index('/')
    "#{self.class.name.tableize.split('_cell')[0].pluralize}/#{path}"
  end

  # inside instance method when you want to render specific template
  def template(template=nil)
    # template is second part part unless defined.
    # for path /action/confirm_email -> template is "confirm_email"
    template ||= Lux.sinatra.request.path.split('/')[2]
    
    path = _find_template_path(template)
    Template.new(path).render( instance_variables_hash )
  end

  # inside instance method when you want to render specific template part
  def template_part(template)
    path = _find_template_path(template)
    Template.new(path).part( instance_variables_hash )
  end

  # inside instance method when you want to class render method
  def render(name, *args)
    self.class.render(name, *args)
  end

  def self.params
    Lux.sinatra.params
  end

  def self.request
    Lux.sinatra.request
  end

  def params
    Lux.sinatra.params
  end

  def request
    Lux.sinatra.request
  end
end

