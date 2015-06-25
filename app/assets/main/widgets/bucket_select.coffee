class window.BucketSelectWidget extends Widget
  init: ->
    value = parseInt @root.attr('value')
    data = JSON.parse @root.html()

    # data.unshift { name:'- part of bucket' }

    ret = []
    ret.push """<div class="select-bucket">"""
    for el in data
      ret.push """<div class="select-option" value="#{el.id}">#{el.name}</div> """

    ret.push '</div>'

    @root.html ret.join("\n")
