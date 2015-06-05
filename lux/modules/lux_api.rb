class LuxApi

  @@opts = {}
  @@actions = {}
  @@params = {}

  # standard recoomended way to create API action
  # action :show do
  #   name        'Show user data'
  #   params      :email, :email, :req
  #   params      :id, :integer
  #   lambda do
  #     @user = User.where(email:params[:email]).first
  #     @user.slice(:id, :name, :avatar, :email)
  #   end
  # end
  def self.action(proc_name)
    proc = yield
    @@actions[proc_name] = @@opts.dup
    @@actions[proc_name][:proc] = proc
    @@opts = {}
  end

  # for quick defineing action with name
  # inline_action :index, 'List all users' do
  #   User.select('id, email, name')
  # end
  def self.inline_action(proc_name, name=nil, &block)
    @@actions[proc_name] = {}
    @@actions[proc_name][:name] = name
    @@actions[proc_name][:proc] = block
    @@opts = {}
  end

  # helper for getting parameters
  def params
    @@params
  end

  # helper for standard definition of parametars
  def self.params(key=nil, *values)
    return @@params unless key
    @@opts[:params] ||= {}
    @@opts[:params][key] = *values
  end

  # helper for standard definition of name
  def self.name(name)
    @@opts[:name] = name
  end

  # helper for standard definition of description
  def self.description(data)
    @@opts[:description] = data
  end

  # helper for standard definition of action
  def self.proc(&block)
    @@opts[:proc] = block
  end

  # public method for running actions on global class
  # use as LuxApi.run 'users', 'show', { email:'rejotl@gmail.com' }
  def self.run(klass, action, options=nil)
    @@params = options || Lux.sinatra.params
    @@params = @@params.reject{ |el| r el; [:captures, :splat].index(el.to_sym) }
    @@params = @@params.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

    klass = (klass.singularize.camelize+'Api').constantize
    klass.new.instance_run(action.to_sym)
  end

  # list all availabe actions in a class
  def self.actions
    instance_level_actions = UserApi.instance_methods - Object.instance_methods - [:sinatra, :instance_run, :params]
    @@actions.keys + instance_level_actions
  end

  # get details about action
  def self.action_details(name)
    @@actions[name] ||= {}
    details = @@actions[name].reject { |key| [:proc].index(key) }
    details[:name] ||= "#{name.to_s} action"
    details
  end

  def sinatra
    Lux.sinatra
  end

  # internal method for running actions
  def instance_run(action)
    @response = {}
    @message  = nil
    @error    = nil

    res = nil

    if @@actions[action]
      res = @@actions[action][:proc].call
    elsif respond_to?(action)
      res = send(action)
    end

    if res
      res = res.call if res.kind_of?(Proc)
      res = res.all.map{ |el| el.attributes } if res.class.name == 'ActiveRecord::Relation'
  
      @response[:data] = res
      @response[:message] = @message if @message
      @error = "Wrong type for @error" if @error && !@error.kind_of?(String)
      @error = "Wrong type for @message" if @message && !@message.kind_of?(String)
    else
      @error = "Action #{action} not found, available #{self.class.actions.to_sentence}"
    end

    @response[:error] = @error if @error
    @response[:ip] = '127.0.0.1'
    @response[:params] = @@params if @@params.keys.length > 0
    @response
  end

end

class LuxApiRender

  def self.render_root
    data = []
    
    @modules = []

    for api_file in Dir["./app/api/*.rb"].map{ |el| el.split('/').last.split('_api.rb').first }
      data = {}.h
      data[:name] = api_file.humanize.pluralize
      data[:location] = "/api/#{api_file.pluralize}"
      data[:actions]  = "#{api_file}_api".classify.constantize.actions

      @modules.push data
    end

    Template.part('api', instance_variables_hash)
  end

  def self.get(*path)
      return Lux.error 'API error: action not defined' unless path[1]
      return LuxApi.run path[0], path[1]
  end

end
