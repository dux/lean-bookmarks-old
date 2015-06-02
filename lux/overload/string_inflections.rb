class String
  def pluralize
    Lux.irregulars[self] || self+'s'
  end
end

Lux.irregular 'bonus', 'bonuses'
Lux.irregular 'clothing', 'clothes'


# https://github.com/datamapper/extlib/blob/master/lib/extlib/inflection.rb

# class String
#   def humanize(options = {})
#     result = self.to_s.dup
#     result.sub!(/\A_+/, '')
#     result.sub!(/_id\z/, '')
#     result.tr!('_', ' ')

#     if options[:capitalize]
#       result.sub!(/\A\w/) { |match| match.upcase }
#     end

#     result.gsub!(/([a-z\d]*)/i) do |match|
#       "#{false || match.downcase}"
#     end

#     result
#   end

#   # def constantize___
#   #   camel_cased_word = self
#   #   unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
#   #     raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
#   #   end

#   #   Object.module_eval("::#{$1}", __FILE__, __LINE__)
#   # end

#   # ovaj je iz railsa, valjda je bolji
#   def constantize
#     camel_cased_word = self
#     names = camel_cased_word.split('::')

#     # Trigger a built-in NameError exception including the ill-formed constant in the message.
#     Object.const_get(camel_cased_word) if names.empty?

#     # Remove the first blank element in case of '::ClassName' notation.
#     names.shift if names.size > 1 && names.first.empty?

#     names.inject(Object) do |constant, name|
#       if constant == Object
#         constant.const_get(name)
#       else
#         candidate = constant.const_get(name)
#         next candidate if constant.const_defined?(name, false)
#         next candidate unless Object.const_defined?(name)

#         # Go down the ancestors to check if it is owned directly. The check
#         # stops when we reach Object or the end of ancestors tree.
#         constant = constant.ancestors.inject do |const, ancestor|
#           break const    if ancestor == Object
#           break ancestor if ancestor.const_defined?(name, false)
#           const
#         end

#         # owner is in Object, so raise
#         constant.const_get(name, false)
#       end
#     end
#   end

#   def classify
#     word = self.to_s.dup
#     word.to_s.sub(/.*\./, '').camelize.singularize
#   end

#   def singularize
#     word = self.to_s.dup
#     return @inf if (@inf=Lux.irregulars[word])
#     word.sub!(/s$/,'')
#     word
#   end

#   def plurazlize
#     word = self.to_s.dup
#     return @inf if (@inf=Lux.irregulars[word])
#     word+'s'
#   end

# end


