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
    @@template_cache[@template] ||= Haml::Engine.new(data)
    @engine = @@template_cache[@template]
  end  

  def self.part(path, opts={})
    Template.new(path).part(opts)
  end

  def self.render(path, opts={})
    Template.new(path).render(opts)
  end

  def part(opts={})
    base_class = @template.split('/')[3]

    helper = LuxHelper.new
    eval %[helper.extend DefaultHelper] rescue false
    eval %[helper.extend #{base_class.capitalize}Helper] rescue false

    Lux.try "Template [#{@template}] render error" do
      @engine.render(helper, opts) do
        yield if block_given?
      end
    end
  end

  def render(opts={})
    @part_data = part(opts)
    layout_path = "#{@original_template.split('/')[0]}/layout"
    Template.new(layout_path).part do
      @part_data
    end
  end

end


