# .widget.toggle{ :button=>'Add new trigger', :close=>1 }
#   Data

# .widget.toggle
#   .on
#     %button{ :onclick=>'$w(this).toggle()' } click

#   .off
#     .well{ :onclick=>'$w(this).toggle()' } abcdefg

String::trunc = String::trunc or (n) ->
  (if @length > n then @substr(0, n - 1) + "&hellip;" else this)

class window.ToggleWidget extends Widget
  init: ->
    @on_state  = @html.find('.on').first().html()
    @off_state = @html.find('.off').first().html()

    if @opts['button']
      @on_state = """<button class="btn btn-default" onclick="#{@widget}.toggle()">#{@opts['button']} &darr;</button>"""
      @off_state = @html.html()
      if @opts['close']
        @off_state = """<span style="float:right; color:#aaa; font-size:18pt; font-weight:bold; margin-right:10px; margin-bottom:-40px;" onclick="$w(this).toggle()" title="Zatvori">&times;</span>#{@off_state}"""

  render: ->
    if @opts['inactive']
      @root.html @off_state
    else
      @root.html @on_state
    Pjax.on_get()

  toggle: ->
    @set('inactive', if @opts['inactive'] then 0 else 1)
    @render()
    if @opts['inactive'] && @opts['animate']
      @root.hide()
      @root.slideDown(200)
