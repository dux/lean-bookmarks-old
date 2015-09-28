# html = render.tag 'head', ->
#   [
#     @h1 class:'test', -> @tag('small', 'product') + 'Dux'
#     @div -> 
#       [2,4,6,7].map (el) =>
#         @li el
#     @tag '.bla.blo', 'div.bla'
#     @tag '#bla.klass', 'div id bla'
#   ]

@render =
  tag: (name, opts, data) ->
    if ['string','function','number'].indexOf(typeof(opts)) > -1
      data = opts
      opts = {}

    if name.indexOf('.') > -1
      parts = name.split('.')
      name = parts.shift() || 'div'
      opts['class'] = parts.join(' ')

    if name.indexOf('#') > -1
      parts = name.split('#',2)
      name = parts.shift() || 'div'
      opts['id'] = parts[0]

    if typeof(data) == 'function'
      data = data.call(@)
 
    if typeof(data) == 'object'
      data = data.join('')

    tags = []
    for k,v of opts
      tags.push " #{k}='#{v}'"

    """\t<#{name}#{tags.join(' ')}>#{data}</#{name}>\n"""

 
for el in 'div.span.a.small.ul.ol.dl.dt.dd.li.h1.h2.h3.h4.h5.h6'.split('.')
  eval """ window.render.#{el} = function(opts, data) { return window.render.tag('#{el}', opts, data); } """
  # window.t[el] = (opts, data) -> window.t.tag(el, opts, data) 