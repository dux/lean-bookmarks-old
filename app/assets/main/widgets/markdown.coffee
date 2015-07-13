Widget.register 'markdown', 
  init: ->
    return alert 'Marked markdown parser is not loaded' unless marked?

    return '' unless /\w/.test(@root.innerHTML)

    @root.innerHTML = marked @root.innerHTML

