class MasterApi

  @@methods = {}

  def self.params(opts)
    @@last_params = opts
  end

  def self.name(name)
    @@last_name = name
  end

  def self.action(name, opts={}, &block)
    # opts[:block] = &block
    @@methods[name] = opts
    @@methods[:params] = @@last_params if @@last_params
    @@methods[:name]   = @@last_name if @@last_name
    @@last_params = nil
    @@last_name = nil
  end

  def run(what, options)

  end

end






class UserApi < MasterApi

  params email: [:email, :req], id: :integer
  action :show, { name:'Show user data',  description:'Shows user data' } do
    return 12344
  end

end


UserApi.run(:show, { email:'rejotl@gmail.com'})