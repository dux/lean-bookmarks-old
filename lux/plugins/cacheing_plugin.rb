require 'active_support/concern'

module CacheingPlugin

  module Model
    extend ActiveSupport::Concern

    class_methods do

      def belongs_to_cached(klass)
        begin
          Cache.get('_test')  
        rescue
          puts "Memcached error: #{$!.message}".red
          exit
        end

        puts "* belongs_to_cached: #{name.classify}.#{klass}".yellow
        define_method klass do
          val = self["#{klass}_id"]
          return nil unless val
          Cache.fetch "#{klass}/#{val}" do
            klass.to_s.classify.constantize.unscoped.find(val)
          end
        end
      end

      # this works nicely
      def find(*args)
        return super(*args) unless args[0].kind_of?(Integer) && !args[1]

        Cache.fetch "#{name.underscore}/#{args[0]}" do
          unscoped.where(id:args[0]).first
        end
      end
    end

    included do
      after_save_and_destroy { Cache.delete "#{self.class.name.underscore}/#{id}" }
    end

    def touch
      Cache.delete "#{self.class.name.underscore}/#{id}"
      super
    end

    def creator
      Cache.fetch "user/#{created_by}" do
        User.unscoped.find(created_by)
      end
    end

    def updater
      Cache.fetch "user/#{updated_by}" do
        User.unscoped.find(updated_by)
      end
    end
  end

end
