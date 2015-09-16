Widget.register 'markdown', 
  init: ->
    return alert 'Marked markdown parser is not loaded' unless marked?

    return '' unless /\w/.test(@root.innerHTML)

    data = marked @root.innerHTML
    data = data.replace(/\[\]/g, '<input type="checkbox" onclick="return false;" />')
    data = data.replace(/\[x\]/g, '<input type="checkbox" checked="" onclick="return false;" />')

    @root.innerHTML = data

