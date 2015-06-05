require 'json'
require 'pp'
require 'activerecord'

class LuxApi

  @@opts = {}
  @@actions = {}
  @@params = {}

  def self.params(key=nil, *values)
    return @@params unless key
    @@opts[:params] ||= {}
    @@opts[:params][key] = *values
  end

  def self.name(name)
    @@opts[:name] = name
  end

  def self.description(data)
    @@opts[:description] = data
  end

  def self.proc(&block)
    @@opts[:proc] = block
  end

  def self.action(proc_name)
    proc = yield
    @@actions[proc_name] = @@opts.dup
    @@actions[proc_name][:proc] = proc
    @@opts = {}
  end

  def self.inline_action(proc_name, name=nil, &block)
    @@actions[proc_name] = {}
    @@actions[proc_name][:name] = name
    @@actions[proc_name][:proc] = block
    @@opts = {}
  end

  def self.run(what, options={})
    klass, proc_name = what.split('#')
    klass = klass.singularize.camelize+'Api'
    puts klass

    @response = {}
    @error = {}
    @message  = nil
    @@params = options
    res = @@actions[proc_name] ? @@actions[proc_name][:proc].call : send(proc_name)
    res = res.call if res.kind_of?(Proc)
    @@_params = options
    @response[:data] = res
    @response[:message] = @message if @message
    @response[:error] = @error if @error
    @response[:ip] = '127.0.0.1'
    @response[:params] = options
    @response
  end

  def self.actions
    instance_level_actions = UserApi.instance_methods - Object.instance_methods    
    @@actions.keys + instance_level_actions
  end

  def self.action_details(name)
    @@actions[name] ||= {}
    details = @@actions[name].reject { |key| [:proc].index(key) }
    details[:name] ||= "#{name.to_s} action"
    details
  end

  def sinatra
    Lux.sinatra
  end

end


class UserApi < LuxApi

  action :show do
    name        'Show user data'
    params      :email, :email, :req
    params      :id, :integer
    lambda do
      @user = User.where(email:params[:email]).first
      @user.slice(:id, :name, :avatar, :email)
    end
  end

  def inline
    'inline'
  end

  # inline_action :index
  #   lambda do
  #     return 1
  #     2
  #   end
  # end

  # inline_action :index do -> {
  #     return 1
  #     2
  # } end

  inline_action :index do
      @error =   'some error'
      next 1
      2
  end

  inline_action :name do
    @message = 'name added'
    'Dux'
  end

end

pp LuxApi.run('user#show', { email:'rejotl@gmail.com'})
# pp UserApi.run(:index, { email:'rejotl@gmail.com'})
# pp UserApi.run(:name)
# pp UserApi.run(:inline)

# puts 'Desc'

# for el in UserApi.actions
#   pp UserApi.action_details(el)
# end

