require 'active_support/concern'

module EssentialsPlugin
  
  module Model
    extend ActiveSupport::Concern

    class_methods do
      def paginate(per_page=20, page_var=:page)
        page = Page.params[page_var] || 1
        page = page.to_i - 1

        ret = where({}).limit(per_page).offset(page * per_page).all.to_a
        ret.define_singleton_method(:paginate_var) do; page_var ;end
        ret.define_singleton_method(:paginate_page) do; page ;end
        ret.define_singleton_method(:paginate_per_page) do; per_page ;end
        ret.define_singleton_method(:paginate) do; per_page ;end
        ret
      end

      def scoped(options=nil)
        options ? where(nil).apply_finder_options(options, true) : where(nil)
      end

      def after_save_and_destroy(&block)
        after_save block
        after_destroy block
      end

      def pg(page, per_page=25)
        self.paginate(page:page, per_page:per_page)
      end

      def by(usr); where(:created_by=>(usr.class.name=='User' ? usr : usr.id));  end
      def active(field='active'); where("#{field}='t'"); end
      def inactive(field='active'); where("coalesce(#{field}, 'f')='f'"); end
      def random; order('random()'); end
      def desc; order('id desc'); end
      def last_updated
        unscoped.order(column_names.index('updated_at') ? 'updated_at desc' : 'id desc').first
      end
      def my_last_updated
        unscoped.order(column_names.index('updated_at') ? 'updated_at desc' : 'id desc').can.first
      end

    # search modules
      def xwhere(opts={})
        ret = {}
        for k,v in opts
          next if v == 0 and k =~ /_id$/
          ret[k] = v if v.present?
        end
        where(ret)
      end

      def like(search, *args)
        unless search.blank?
          search = search.gsub(/'/,"''").downcase
          where_str = []
          for str in search.split(/\s+/).select(&:present?)
            and_str = []
            vals = []
            str = "%#{str}%"
            for el in args
              and_str << "#{el} ilike '#{str}'"
            end
            where_str.push '('+and_str.join(' or ')+')'
          end
          return where(where_str.join(' and '))
        end
        scoped
      end
      
      def where_id_in(sql, *args)
        return where("id in (#{sql})", *args) unless sql =~ /limit\s+\d/i
        list = connection.select_values(sql).map(&:to_i)
        return where("id in (?)", list)
      end

      def my
        raise 'Not loged in for my' unless User.current
        where('created_by=?', User.current.id)
      end

    # automatic api calls
      def api(method, params={})
        ret = "#{self.name}Api".constantize.new(params).exec method
        raise "API call error: #{ret[:error]}" if ret[:error]
        ret[:data]
      end

      def search_or_new(filter)
        self.where(filter).first || self.new(filter)
      end

      def search_or_create(filter)
        self.where(filter).first || self.create(filter)
      end

      def ids
        connection.select_values(to_sql).map(&:to_i)
      end

      def raw(sql=nil)
        MasterModel.connection.select_all(sql).map{ |el| Hashie::Mash.new(el) }
      end

      def get(id)
        unscoped.find(id.to_i).can
      end

      def for(obj)
        # column_names
        field_name = "#{obj.class.name.underscore}_id".to_sym
        n1 = self.name.underscore
        n2 = obj.class.name.underscore
        cname = n1[0] < n2[0] ? n1+'_'+n2.pluralize : n2+'_'+n1.pluralize

        if ActiveRecord::Base.connection.table_exists?(cname) # linkana tablica
          where("id in (select #{n1}_id from #{cname} where #{n2}_id=?)", obj.id)
        elsif new.respond_to?(field_name)
          return where("#{field_name}=?", obj.id)
        elsif new.respond_to?(:grp_type) 
          return where(:grp_type=>obj.class.name, :grp_id=>obj.id)
        elsif obj.class.name == 'User'
          # imas slučaj kada se ovo ne lovi na početku klase, misterija
          if new.respond_to?(field_name)
            return where("#{field_name}=?", obj.id)
          end
          return where('created_by=?', obj.id)
        else
          r 'Unknown link'
        end
      end

    end

    included do
      class_attribute :base_route

      # escape all HTML entities
      before_save do
        for k,v in attributes
          v.gsub!('<','&lt;') if v.kind_of?(String)
          v.gsub!('>','&gt;') if v.kind_of?(String)
        end
      end
    end

    def token
      Crypt.encrypt("#{self.class.name}:#{id}")
    end

    def api(method, params={})
      ret = "#{self.class.name}Api".constantize.new(params, id).exec method
      ret[:data]
    end

    # activity.path = activity.to_param, just an alias
    # activity.path -> base route
    # activity.path(:test) -> base route + '/test'
    # activity.path(:admin) -> '/admin' + base route
    def path(url=nil)
      base = self.class.name.underscore.downcase.singularize
      return "/admin/#{base}/#{self.id}" if url == :admin
      base = self.base_route? ? self.base_route : base
      locale = I18n.available_locales.length > 1 ? "/#{I18n.locale}" : ''
      return "#{locale}/#{base}/#{StringBase.encode(self.id)}/#{url}" if url
      return '/'+self[:route] if self[:route].present?
      # return "/#{base}/#{self.id}-#{name.to_s[0,50].parameterize rescue ''}"
      "#{locale}/#{base}/#{StringBase.encode(self.id)}"
    end
    def to_param(url=nil); path(url); end

    def as_link(url=nil, opt={})
      opt[:href] = self.path(url)
      opt.tag('a', self.name).html_safe
    end

    def error_messages
      ret = []
      for k,v in errors
        ret.push(v) rescue ''
      end
      ret.join(', ')
    end

    def slice(*args)
      ret = {}
      for el in args
        ret[el] = send el
      end
      ret
    end

    def as_url_param(key=nil)
      %[o_#{Crypt.encrypt(key||self.class.name.tableize.singularize)}=#{Crypt.encrypt("#{self.class.name}:#{id}")}]
    end

    def id_sb
      StringBase.encode(self.id)
    end

    # grp object
      def grp_object(obj=nil)
        return grp_type.classify.constantize.find_by_id( grp_id ) unless obj
        self[:grp_type] = obj.class.name
        self[:grp_id] = obj.id
        self
      end

      def grp_object=(obj=nil)
        self[:grp_id] = obj.id
        self[:grp_type] = obj.class.name
      end

    # my?
      def my?
        return false unless User.current
        return true if User.current.id == created_by
        return false
      end

      def for(obj)
        return self.grp_object unless obj
        field_name = obj.class.name.underscore+'_id'
        # if respond_to?(field_name)
        if attributes.keys.index(field_name)
          self[field_name.to_sym] = obj.id
        else
          self[:grp_id] = obj.id
          self[:grp_type] = obj.class.name
        end
        self
      end

  end
end