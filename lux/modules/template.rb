# Haml::Template.options[:ugly] = true

class Template
  @@template_cache = {}

  def initialize(template)
    template.sub! /^[^\w]+/, ''
    @original_template = template

    for dir in ['./app/views','./lux/views']
      for ext in ['haml', 'erb']
        next if @template
        test = "#{dir}/#{template}.#{ext}"
        @template = test if File.exists?(test)
      end
    end

    raise "Template [#{template}] not found" unless @template

    # clear only once per request
    @@template_cache = {} if Lux.dev? && !Thread.current[:lux][:template_cache]
    Thread.current[:lux][:template_cache] = true

    @@template_cache[template] ||= Tilt.new(@template, :ugly=>true)
    @engine = @@template_cache[template]
  end  

  def self.helper(base_class, opts={})
    base_class = base_class.to_s
    
    helper = LuxHelper.new
    # if base class is defined, use it, othervise use application global class
    if ("#{base_class.capitalize}Helper".constantize rescue false)
      eval %[helper.extend #{base_class.capitalize}Helper]
    else
      eval %[helper.extend ApplicationHelper] rescue false
    end

    for k, v in opts
      helper.instance_variable_set("@#{k.to_s.sub('@','')}", v)
    end

    for k, v in Lux.locals
      helper.instance_variable_set("@#{k.to_s.sub('@','')}", v)
    end
    helper
  end

  def self.part(path, opts={})
    Template.new(path).part(opts)
  end

  def self.render(path, opts={})
    Template.new(path).render(opts)
  end

  def self.last_template_path
    Thread.current[:last_template_path]
  end

  def part(opts={})
    base_class = @template.split('/')[3]

    Thread.current[:last_template_path] = @template.sub('/app/views','').sub(/\/[^\/]+$/,'').sub(/^\./,'')

    helper = Template.helper(base_class, opts)

    Lux.try "Template [#{@template}] render error" do
      @engine.render(helper) do
        yield if block_given?
      end
    end
  end

  def render(opts={})
    @part_data = part(opts)
    layout_path = "#{@original_template.split('/')[0]}/layout"
    Template.new(layout_path).part(opts) do
      @part_data
    end
  end

end


