#MasterApp 
# :get    - return any data
# :part   - render only part
# :render - render part with layout

class MasterApp

  def self.get(*args)
    copy = args.dup
    method_name = copy.shift

    obj = new
    
    unless obj.respond_to?(method_name)
      list = self.instance_methods - Object.instance_methods
      list -= [:render, :render_part]

      err = ["No instance method <b>#{method_name}</b> in class <b>#{self.name}</b>"]
      err.push %[You have defined \n- #{(list).join("\n- ")}]
      return Lux.error!(err)
    end
    
    obj.send(method_name, *copy)
  end

  def self.part(*args)
    copy = args.dup
    method_name = copy.shift
    obj = new
    obj.send(method_name, *copy)
    @local_path = obj.class.name.index('::') ? obj.class.name.sub(/App$/,'').tableize : obj.class.name.sub(/App$/,'').downcase
    @local_path += "/#{method_name}"
    @part_data = Template.new(@local_path).render( obj.instance_variables_hash )
    @part_data
  end

  def self.render(*args)
    @part_data = part(*args)
    layout_path = "#{@local_path.split('/')[0]}/layout"
    Template.new(layout_path).render do
      @part_data
    end
  end

  def initialize(opts={})
  
  end

  def sinatra
    Lux.sinatra
  end

  def render(template)
    Template.new("main/#{template}").render( instance_variables_hash )
  end

  def render_part(template)
    Template.new("main/#{template}").render( instance_variables_hash )
  end

end