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
  def self.action(proc_name, &block)
    @@actions[proc_name] = @@opts.dup
    @@actions[proc_name][:proc] = block
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

  # public mount method
  def self.raw(*path)
    return 'Unsupported API call' if path[3]
    return 'Unsupported API call' unless path[1]
      
    opts = Lux.params

    return run(path[0], path[1], opts) unless path[2]
    
    opts[:id] = path[1]
    r opts[:id]

    return run(path[0], path[2], opts)
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
    @@params = options || Lux.params
    @@params.delete_if{ |el| [:captures, :splat].index(el.to_sym) }

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
    details[:action] ||= name
    details.h
  end

  # internal method for running actions
  def instance_run(action)
    @response = {}
    @message  = nil
    @error    = nil

    res = nil

    if @@actions[action] && @@actions[action][:params]
      for k,v in @@actions[action][:params]
        next if @error
        value = params[k]
        eval "@_#{k} = value"
        for type in v
          case type
            when :req          
              @error = "[#{k}] is required" unless value
            when :email
              begin
                Validate.email value                
              rescue
                @error ||= "[#{k}] #{$!.message}"     
              end
          end
        end
      end
    end

    unless @error
      begin
        if @@actions[action]
          res = instance_eval(&@@actions[action][:proc])
        elsif respond_to?(action)
          res = send(action)
        end
      rescue
        @error ||= $!.message.split(' for #').first
        @response[:backtrace] = $!.backtrace.select{ |el| el.index('/app/') }.map{ |el| el.split('/app/', 2)[1] } if Lux.dev?
      end
    end

    if res
      res = instance_eval(&res) if res.kind_of?(Proc)
      res = res.all.map{ |el| el.attributes } if res.class.name == 'ActiveRecord::Relation'
  
      @response[:data] = res
      @response[:message] = @message if @message
      # @response[:message] = res if !@message && res.kind_of?(String)
      @error ||= "Wrong type for @error" if @error && !@error.kind_of?(String)
      @error ||= "Wrong type for @message" if @message && !@message.kind_of?(String)
    else
      @error ||= "Action #{action} not found, available #{self.class.actions.to_sentence}"
    end

    @response[:error] = @error if @error
    @response[:ip] = '127.0.0.1'
    # @response[:params] = @@params if @@params.keys.length > 0
    @response
  end

end

