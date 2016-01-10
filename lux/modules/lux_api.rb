require 'pp'

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

  # public mount method
  def self.resolve(path)
    return 'Unsupported API call' if !path[1] || path[3]

    @@class_name = path[0].classify

    opts = Page.params

    return run(path[0], path[1], opts) unless path[2]

    # set path vaiable to id
    opts[:_id] = path[1]

    return run(path[0], path[2], opts)
  end

  # public method for running actions on global class
  # use as LuxApi.run 'users', 'show', { email:'rejotl@gmail.com' }
  def self.run(klass, action, options=nil)
    @@params = options || Page.params
    @@params.delete_if{ |el| [:captures, :splat].index(el.to_sym) }

    if @@params[@@class_name.underscore]
      begin
        @@params.merge! @@params.delete(@@class_name.underscore)
      rescue
        raise "#{$!.message}. Domain value is probably, not hash, invalid parameter #{@@class_name.underscore}"
      end
    end

    klass = (klass.singularize.camelize+'Api').constantize
    klass.new.instance_run(action.to_sym)
  end

  # internal method for running actions
  def instance_run(action)
    @response = {}
    @message  = nil
    @error    = nil

    res = nil

    # load default object
    if @@params[:_id]
      eval "@object = @#{@@class_name.underscore} = #{@@class_name}.unscoped.find(@@params[:_id].to_i)"
      @response[:path] = @object.path
    end

    if @@actions[action] && @@actions[action][:params]
      for key, values in @@actions[action][:params]
        next if @error
        value = @@params[key]
        eval "@_#{key} = value" if value.present?
        for type in values
          case type
            when :req
              @error = "[#{key}] is required" unless value
            when :email
              begin
                Validate.email value
              rescue
                @error ||= "[#{key}] #{$!.message}"
              end
          end
        end
      end
    end

    unless @error
      begin
        if @@actions[action]
          res = instance_exec &@@actions[action][:proc]
        elsif respond_to?(action)
          res = send(action)
        else
          @error ||= "Action #{action} not found in #{self.class.name.sub('Cell','')} API, available #{self.class.actions.to_sentence}"
        end
      rescue
        if $!
          @error ||= $!.message.split(' for #').first
          root = __FILE__.sub('lux/lux/modules/lux_api.rb','')
          @response[:backtrace] = $!.backtrace.reject{ |el| el.index('/gems/') }.map{ |el| el.sub(root, '') }
        end
      end
    end

    if res
      res = instance_eval(&res) if res.kind_of?(Proc)
      res = res.all.map{ |el| el.attributes } if res.class.name == 'ActiveRecord::Relation'

      # object given
      if res.respond_to?(:attributes)
        @response[:path] = res.path if res.respond_to?(:path)
        res = res.attributes.reject{ |f| ['updated_by', 'updated_at', 'created_by', 'created_at'].index(f) }
      end

      @response[:data] = res
      @response[:message] = @message unless @message.nil?
      # @response[:message] = res if !@message && res.kind_of?(String)
      @error ||= "Wrong type for @error" if @error && !@error.kind_of?(String)
      @error ||= "Wrong type for @message" if @message && !@message.kind_of?(String)
    end

    # if we define _redirect then we will be redirected to exact page
    # useful for file uploads
    if @@params[:_redirect]
      if @error
        Page.flash :error, @error
      elsif @response[:message]
        Page.flash :info, @response[:message]
      end

      Page.redirect(@@params[:_redirect])
    end

    @response[:error] = @error if @error
    @response[:ip] = '127.0.0.1'
    ap @response if Page.dev?
    @response
  end


  # default active model

  def can?(what, object=nil)
    object ||= @object
    raise "#{@@class_name} not found, can't check for :#{what} permission" unless object
    raise "No [#{what}] permission on #{object.class.name}" unless object.can? what
  end

  def report_errros_if_any(obj)
    if obj.errors.count > 0
      error = []
      @response[:errors] = {}
      for k,v in obj.errors
        @response[:errors][k] = v
        error.push v
      end
      raise error.join ', '
    end
  end

  def create
    @object = @@class_name.constantize.new

    @last = @@class_name.constantize.my.last rescue @@class_name.constantize.last
    if @last && @last[:name].present? && @last[:name] == params[:name]
      raise "#{@class_name} is same as last one created."
    end

    old = @object.attributes
    for k,v in @@params
      eval %[@object.#{k} = v] if old.keys.index(k.to_s)
    end
    can? :create
    @object.save
    report_errros_if_any @object
    @message = "#{@@class_name.capitalize} created"
    @response[:path] = @object.path
    @object.attributes
  end

  def show
    can? :read
    @object.attributes
  end

  def update
    old = @object.attributes

    for k,v in @@params
      eval %[@object.#{k} = v] if old.keys.index(k.to_s)
    end

    can? :write
    @object.save

    report_errros_if_any @object
    @message = "#{@@class_name} updated"
    @response[:path] = @object.path
    @object.attributes
  end

  # if you put active boolean field to objects, then they will be unactivated on destroy
  def destroy
    can? :write

    if @object.respond_to?(:active)
      @object.update_attributes :active=>false
      return @message = 'Object deleted (exists in trashcan)'
    end

    @object.destroy
    report_errros_if_any @object
    @message = "#{@object.class.name} deleted"
    @object.attributes
  end

  def undelete
    can? :write

    if @object.respond_to?(:active)
      @object.update_attributes :active=>true
      @message = 'Object raised from the dead.'
    else
      @message = 'Object has no attriute [active]'
    end

  end

  def index
    @error = 'No index method defiend'
  end

end

