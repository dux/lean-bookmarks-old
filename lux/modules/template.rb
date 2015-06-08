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


    @@template_cache[template] ||= Tilt.new(@template)
    @engine = @@template_cache[template]
  end  

  def self.part(path, opts={})
    Template.new(path).part(opts)
  end

  def self.render(path, opts={})
    Template.new(path).render(opts)
  end

  def self.last_template_path
    @@last_template_path
  end

  def part(opts={})
    base_class = @template.split('/')[3]

    @@last_template_path = @template.sub('/app/views','').sub(/\/[^\/]+$/,'').sub(/^\./,'')

    helper = LuxHelper.new
    eval %[helper.extend DefaultHelper] rescue false
    eval %[helper.extend #{base_class.capitalize}Helper] rescue false
    
    for k, v in opts
      helper.instance_variable_set(k, v)
    end

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


