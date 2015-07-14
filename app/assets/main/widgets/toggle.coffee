Widget.register 'toggle', 
  init: ->
    $base = $ @root
    @on_state  = $base.find('.on').first().html()
    @off_state = $base.find('.off').first().html()

    if @opts['button']
      @on_state = """<button class="btn btn-default" onclick="#{@widget}.toggle()">#{@opts['button']} &darr;</button>"""
      @off_state = $base.html()

      if @opts['close']
        @off_state = """<span style="float:right; color:#aaa; font-size:18pt; font-weight:bold; margin-right:10px; margin-bottom:-40px;" onclick="$w(this).toggle()" title="Zatvori">&times;</span>#{@off_state}"""

  render: ->
    if @opts['inactive']
      @root.innerHTML = @off_state
    else
      @root.innerHTML = @on_state

    # Pjax.on_get()

  toggle: ->
    @set('inactive', if @opts['inactive'] then 0 else 1)
    @render()
    if @opts['inactive'] && @opts['animate']
      @root.hide()
      @root.slideDown(200)
