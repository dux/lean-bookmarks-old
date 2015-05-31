require 'haml'

class Template
  @@template_cache = {}

  def initialize(template)
    template.sub!(/^\//,'')
    @original_template = template
    @template = "./app/views/#{template}.haml"
    unless File.exists?(@template)
      @template = "./lux/views/#{template}.haml" 
      raise "Template [#{@template}] not found" unless File.exists?(@template)
    end
    data = File.read(@template)

    # only engine for now
    # @engine = Haml::Engine.new(data)
    if Lux.in_production
      @@template_cache[@template] ||= Haml::Engine.new(data)
      @engine = @@template_cache[@template]
    else
      @engine = Haml::Engine.new(data)
    end
  end  

  def render(opts={})
    base_class = @template.split('/')[3]

    helper = MasterHelper.new
    eval %[helper.extend #{base_class.capitalize}Helper]

    Lux.try "Template [#{@template}] render error" do
      @engine.render(helper, opts) do
        yield if block_given?
      end
    end
  end

  def self.with_layout(path, opts={})
    Template.new(path).with_layout(opts)
  end

  def with_layout(opts={})
    @part_data = render(opts)

    layout_path = "#{@original_template.split('/')[0]}/layout"
    Template.new(layout_path).render do
      @part_data
    end
  end

end


