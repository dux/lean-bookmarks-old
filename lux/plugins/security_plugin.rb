require 'active_support/concern'

module SecurityPlugin
  
  module Model
    extend ActiveSupport::Concern

    class_methods do

      def can(what=:read)
        return where(:created_by=>User.current.id) if what == :write
        where({})
      end

    end

    def can?(what=:read)
      return true if what == :read
      return false unless User.current
      return true if User.current.is_admin
      return true if respond_to?(:created_by) && my?
      return grp_object.can?(what) if respond_to?(:grp_id)
      return false
    end

    def can(what=:read)
      return self if can?
      raise '403'
    end

    def f(what, unsafe=false)
      what = StringBase.decode(what) if what.to_s != what.to_i.to_s
      ret = unscoped.find(what)
      unsafe ? ret : ret.can
    end
  end

end
