module PgarrayPlugin
  module Model
    extend ActiveSupport::Concern
    included do
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
          end

          def #{field}
            self[:#{field}].join(', ')
          end

          after_initialize do
            self[:#{field}] ||= []
          end
        ]
        end
      end
    end
  end
end
