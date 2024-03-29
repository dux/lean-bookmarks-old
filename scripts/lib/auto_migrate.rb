#!/usr/bin/env ruby

require 'ap'
require 'yaml'
require 'active_support'
require 'active_record'
require 'colorize'

class AutoMigrate
  attr_accessor :fields

  def initialize(table_name)
    @table_name = table_name
    @fields = {}
  end

  def self.connect(opts)
    puts "#{opts['adapter']}://#{opts['username']}@#{opts['database']}".yellow
    puts '--'
    ActiveRecord::Base.establish_connection(opts)
  end

  def self.table(table_name)
    klass = table_name.to_s.classify
    Object.class_eval "class #{klass} < ActiveRecord::Base; end" unless Object.const_defined?(klass)

    unless ActiveRecord::Base.connection.table_exists?(table_name.to_s)
      # ActiveRecord::Migration.drop_table table_name
      ActiveRecord::Base.connection.create_table(table_name)
    end

    t = new(table_name)
    yield(t)
    t.fix_fields
    t.update
  end

  def self.migrate(&block)
    instance_eval(&block)
  end

  def fix_fields
    for field, vals in @fields
      type = vals[0]
      opts = vals[1]

      if type == :string
        opts[:limit] ||= 255 
      end

      if type == :boolean
        opts[:default] ||= false
      end

      opts[:null] = true unless opts[:null].class.name == 'FalseClass'
      opts[:array] ||= false
      opts[:default] = [] if opts[:array]
    end    
  end

  def update
    begin
      obj = @table_name.to_s.classify.constantize
      o = obj.new
    rescue 
      puts "Object #{@table_name.to_s.classify.red} does not exist, yet table #{@table_name.to_s.red} exists!" 
      return
    end

    # remove extra fields
    existing_fields = o.attributes.keys - ['id']
    for field in (existing_fields - @fields.keys.map(&:to_s))
      ActiveRecord::Migration.remove_column @table_name, field
    end

    puts "Table #{@table_name.to_s.yellow}, #{@fields.keys.length} fields"
    
    for field, opts_in in @fields

      type = opts_in[0]
      opts = opts_in[1]
      
      # create missing columns
      unless o.respond_to?(field) 
        ActiveRecord::Migration.add_column @table_name, field, type, opts
        next
      end

      if current = obj.columns_hash[field.to_s]
        current_type = current.cast_type.type

        is_change = false
        is_change = true if current_type != type
        is_change = true if current_type == :string && ((current.limit || 255).to_i != opts[:limit] || current.null != opts[:null])
        is_change = true if current.array != opts[:array]

        if is_change
          puts "#{field} limit:#{current.limit || 255} != #{opts[:limit]}, null:#{current.null} != #{opts[:null]}, array:#{current.array} != #{opts[:array]}"
          ActiveRecord::Migration.change_column  @table_name, field, type, opts
        end
      end

      add_index(field, opts[:index])  if opts[:index]
    end

  end

  def add_index(field, index=nil)
    field = [field, index.to_sym] if index && !index.kind_of?(TrueClass)
    ActiveRecord::Migration.add_index(@table_name, field) unless ActiveRecord::Migration.index_exists?(@table_name, field)
  end

  def rename(field_old, field_new)
    existing_fields = @table_name.to_s.classify.constantize.new.attributes.keys.map(&:to_sym)
    if existing_fields.index(field_old) && ! existing_fields.index(field_new)
      ActiveRecord::Migration.rename_column(@table_name, field_old, field_new)
    end
  end

  def method_missing(type, *args)
    name = args[0]
    opts = args[1] || {}
    # puts "#{@table_name} - #{type} - #{args[0]}"
    if [:string, :integer, :text, :boolean, :datetime].index(type)
      @fields[name] = [type, opts]
    elsif type == :timestamps
      opts[:null] ||= false 
      @fields[:created_at] = [:datetime, opts]
      @fields[:created_by] = [:integer, opts]
      @fields[:updated_at] = [:datetime, opts]
      @fields[:updated_by] = [:integer, opts]
    elsif type == :polymorphic
      @fields["#{name}_id".to_sym]   = [:integer, opts]
      @fields["#{name}_type".to_sym] = [:string, opts.merge(:limit=>100, :index=>"#{name}_id")]
    else
      puts "Unknown #{type.to_s.red}"
    end
  end
end


