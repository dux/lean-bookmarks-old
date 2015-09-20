# tpl_data = {
#   products:[
#     { id:1, name:'Mac' },
#     { id:2, name:'PC' },
#     { id:3, name:'UNIX' }
#   ]
# }

# Jaml.render tpl_data do
#   html(
#     head(
#       title('Naslov'),
#       meta({ name:'robots', value:'index, follow' })
#     ),
#     -> {
#       100.times do
#         body({ class:'product'},
#           h1('Dober dan'),
#           ul(->{
#             locals[:products].map do |el|
#               tag :li, { id:"p-#{el[:id]}"}, el[:name]            
#             end.join('')
#           })
#         )
#       end
#     }
#   )
# end

class Jaml

  attr_reader :response, :locals

  def self.render(locals, &block)
    t = new(locals, &block)
    t.response
  end

  def initialize(locals, &block)
    @locals = locals
    @response = instance_exec(&block).to_s
  end

  def tag(node, opts, text=nil)
    elms = []
    opts.each do |k,v|
      elms.push(k.to_s.gsub(/_/,'-')+'="'+v.to_s.gsub(/"/,'&quot;')+'"') if v# if ['id','title','class','name','data-','onmousedown','onclick','href'].include?k.to_s 
    end
    ret = elms.length > 0 ? ' '+elms.join(' ') : ''
    if node
      text ||= '' if node.to_s == 'button'
      return text ? %{<#{node}#{ret}>#{text}</#{node}>} : %{<#{node}#{ret} />}
    end
    ret
  end

  def element(*args)
    name = args.shift
    opts = {}
    if args[0].kind_of?(Hash)
      opts = args.shift
    end
    element_render name, opts, args.map{ |el|
      el = el.call() if el.kind_of?(Proc)
      el
    }.join('')
  end

  def element_render(name, *args)
    return %[<#{name}></#{name}>] unless args[0]

    if args[0].kind_of?(String) && !args[1]
      return tag name, {}, args[0]
    elsif args[0].kind_of?(String) && args[1].kind_of?(String)
      return tag name, {}, args.join('')
    else
      return tag name, args[0], args[1]
    end
  end

  def method_missing(name, *args)
    element name, *args
  end

end

