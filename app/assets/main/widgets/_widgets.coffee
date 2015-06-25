# exported in init()
# @html
# @root

window.Widgets =
  auto_id: 0
  index: {}
  load: (root_node) ->
    root_node ||= document.body
    $($('.widget').get().reverse()).each -> # have to do it reverse because of nested widgets
      el = $(this)

      return if el.attr('_init')
      el.attr('_init', 'true')

      name = el.attr('rel') || el.attr('class').split(/\s+/)[1]
      return el.html("<span style='color:#800; font-weight:bold;'>Widget error: No widget NAME</span>") unless name

      console.log "Widget: #{name}"

      unless id = el.attr('id')
        Widgets.auto_id += 1
        el.attr('id', "wid-aid-#{Widgets.auto_id}")
        id = el.attr('id')

      class_name = name.charAt(0).toUpperCase() + name.slice(1);
      
      # return el.html("<span style='color:#800; font-weight:bold;'>Widget error: Widget [#{class_name}] not defiend</span>") unless self["#{class_name}Widget"]

      widget = eval "new #{class_name}Widget(el)"
      widget.init()
      widget.render()
      Widgets.index[id] = widget

  get: (id) ->
    unless Widgets.index[id]
      alert "Widget with ID [#{id}] not found"
      return
    Widgets.index[id].re_root()  

  set: (id, name, value) ->
    Widgets.get(id).set(name, value)

  find: (el) ->
    widget = $(el).closest('.widget').first()
    id = widget.attr('id')
    alert "Widget ID not found" unless id
    if Widgets.index[id]
      return Widgets.index[id]
    else
      alert "Widgets.index['#{id}'] not found"


# @root - widget root
# @opts - options
# @html - widget html
class window.Widget
  constructor: (@root, @opts) ->
    @opts ||= {}

    for el in @root[0].attributes
      if ['class','id'].indexOf(el.nodeName) == -1
        @opts[el.nodeName] = el.value

    node_name = @root[0].nodeName
    @widget   = "Widgets.get('#{@root.attr('id')}')"
    @id       = @root.attr('id')
  
    unless @root.val()
      @html     = $("<#{node_name}>#{@root.html()}</#{node_name}>")
      # @root.html('')

  init: -> 1

  render: -> 1

  set: (name, value) ->
    @opts[name] = value
    @root.attr(name, value)
    @render()

  re_root: ->
    @root = $('#'+@id).first()
    @

window.$w = Widgets.find
