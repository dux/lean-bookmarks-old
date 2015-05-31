# class LuxRouter

#   @routes = {}

#   def resolve(what, path_parts=[])
#     what = what.first if what.kind_of?(Array)
#     if what.kind_of?(Hash)
#       case key = what.keys[0]
#         when :template
#           return Template.render(what[:template])
#         when :body
#           return what[:body]
#         else
#           Lux.error! "Unsuported render key [#{key}]"
#       end
#     end
#     what.resolve(path_parts)
#   end

#   def root(*what)
#     @root = what
#   end

#   def get(path_part, *what)
#     @routes[path_part.to_s] = what
#   end

#   def auto(url, *what)
    
#   end

#   def get_data(path=[])
#     return resolve @root if !path || !path[0]
#     first_part = path.shift
#     return Lux.error!("Unknown route [#{first}]") unless @routes[first_part]
#     resolve @routes[first_part], path
#   end

# end
