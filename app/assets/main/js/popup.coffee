# Popup.destroy(this, 'bucket', ->

window.Popup = 
  # close the pupup singleton
  close: -> $('#popup').hide()

  # internat, popup draw
  _init: ->
    console.log 'Popup._init()' if console.log
    insert = $("""<div id="popup" style="display:none;"><span onclick="Popup.close();" style="cursor:pointer;float:right;font-size:14px; color:#aaa;">&#10006;</span><div id="popup_title"></div><div id="popup_body"></div></div>""")
    $(document.body).append insert

  button: ->
    $ $('#popup').data('button')

  # show the popup
  render: (button, title, data) ->
    if typeof data != 'string'
      data = $(data).html()

    @refresh_button = button = $(button)
    popup = $('#popup')

    if popup.length == 0
      Popup._init()
      popup = $('#popup')

    if button[0].nodeName != 'INPUT' && popup.is(':visible') && popup.attr('data-popup-title') == title
       popup.hide();
       return
    
    popup.attr 'data-popup-title', title

    # left_pos_fix = if button.css('float') == 'right' then popup.width() - button.width() - 3 else 0
    left_pos_fix = 0

    there_is_left = $(window).width() - button.offset().left
    if there_is_left < 400
      left_pos_fix = 400 - there_is_left

    popup.css 'left', button.offset().left - left_pos_fix
    popup.css 'top', button.offset().top + button.height() + (if $(button)[0].nodeName == 'INPUT' then 14 else 6)

    $('#popup_title').html title
    $('#popup').data('button', button)
    
    pbody = $('#popup_body')
    if /^\//.test(data) # ic url
      pbody.html '...'
      $.get data, (ret) ->
        pbody.html """<widget url="#{data}">#{ret}</widget>"""
    else
      pbody.html data
      setTimeout =>
        pbody.find('input').first().focus()
      , 100

    popup.show()

  # template for destroy, red button
  destroy: (button, text, func) ->
    data = $("<div style='text-align:center !important;'><button class='btn btn-danger' style='margin:15px auto;'>#{text}</button> or <button class='btn btn-small'>no</button></div>")
    butt = data.find('button').first()

    data.find('.btn-small').on 'click', -> Popup.close()
    butt.on 'mouseover', -> $(this).transition({ scale: 1.1 })
    butt.on 'mouseout', -> $(this).transition({ scale: 1.0 })
    butt.on 'click', -> func()

    Popup.render(button, 'Sure to destroy?', data)

  undelete: (button, obj, id) ->
    data = $("<div style='text-align:center;'><button class='btn btn-primary' style='margin:15px auto;;'>undelete?</button> or <button class='btn btn-small'>no</button></div>")
    butt = data.find('button').first()

    data.find('.btn-small').on 'click', -> Popup.close()
    butt.on 'mouseover', -> $(this).transition({ scale: 1.1 })
    butt.on 'mouseout', -> $(this).transition({ scale: 1.0 })
    butt.on 'click', ->
      Api.send "/api/#{obj}/#{id}/undelete", {}, ->
        Popup.close()
        Pjax.load("/#{obj}/#{id}")

    Popup.render(button, "Recicle object from trash?", data)
    # Modal.confirm { q:'Sure to destroy?', yes:"Destroy #{what}"}, ->
    #  Api.send "#{what}/#{id}/destroy", ->
    #    $(widget).closest('*[data-widget]').hide(300)

  refresh: ->
    Popup.close();
    @refresh_button.click()


  menu: (button, title, array) ->
    data = []
    for el in array
      data.push """<a class="block" onclick="Popup.close();#{el[1]}">#{el[0]}</a>"""

    @render button, title, data.join('')

  data: (data) ->
    $('#popup_body').html(data)
    Pjax.on_get()


