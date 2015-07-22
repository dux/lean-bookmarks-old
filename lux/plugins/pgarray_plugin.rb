module PgarrayPlugin
  module Model
    extend ActiveSupport::Concern
    included do

      # only postgree
      # Bucket.can.can_tags -> can_tags mora biti zadnji
      def self.all_tags(field=:tags, *args)
        sql = scoped.to_sql.split(' FROM ')[1]
        sql = "select lower(unnest(#{field})) as tag FROM " + sql
        sql = "select tag as name, count(tag) as cnt from (#{sql}) as tags group by tag order by cnt desc"
        raw(sql).map{ |el| el.h }.or([])
      end

      def self.tagged_with(tag=nil, field=:tags)
        return scoped unless tag
        where("? = any (#{field})", tag)
      end

      def self.array_on(*fields)
        for field in fields
          self.class_eval %[def #{field}=(data)
            unless data
              self[:#{field}] = []
              return
            end
            if data.kind_of?(String)
              self[:#{field}] = data.split(/\s*,\s*/)
            elsif data.kind_of?(Array)
              self[:#{field}] = data
            else
              self[:#{field}] = []
              for k,v in data
                self[:#{field}][k.to_i] = v
              end
            end
            self[:#{field}] = self[:#{field}].map{ |el| el.gsub(/[^\\w]+/,'-').downcase }
          end

          after_initialize do
            (self[:#{field}] ||= []) rescue false
          end
        ]
        end
      end
    end
  end
end
