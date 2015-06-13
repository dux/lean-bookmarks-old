class LuxHelper

  def capture(&block)
    capture_haml(&block)
  end

  def params
    Lux.sinatra.params
  end

  def request
    Lux.sinatra.request
  end

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
      name = "#{Template.last_template_path}/#{name}" unless name.index('/')
      Template.new(name).part(instance_variables_hash.merge(opts))
    end
  end

  def cell(name, action, *args)
    klass = Template.last_template_path.split('/')[1].classify
    "#{klass}::#{name.to_s.classify}Cell".constantize.part(action, *args)
  end

end

