class MasterApi

  @@opts = {}
  @@actions = {}

  def self.params(key, value)
    @@opts[:params] ||= {}
    @@opts[:params][key] = value
  end

  def self.name(name)
    @@opts[:name] = name
  end

  def self.action(name, &block)
    # opts[:block] = &block
    @@opts[:action] = opts
  end

  def run(what, options)

  end

end






class UserApi < MasterApi

  params email: [:email, :req], id: :integer
  action :show, { name:'Show user data',  description:'Shows user data' } do
    return 12344
  end

  action :index do
    return 1234435345345
  end

end


UserApi.run(:show, { email:'rejotl@gmail.com'})