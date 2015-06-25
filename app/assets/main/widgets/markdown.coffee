class window.MarkdownWidget extends Widget
  init: ->
    @root.html marked @root.html()

