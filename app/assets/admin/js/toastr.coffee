@Info = 
  ok: (msg) -> Info.show('success', msg)
  info: (msg) -> Info.show('info', msg)
  noteice: (msg) -> Info.show('info', msg)
  success: (msg) -> Info.show('success', msg)
  error: (msg) -> Info.show('error', msg)
  alert: (msg) -> Info.show('error', msg)
  warning: (msg) -> Info.show('warning', msg)
  auto: (res, follow_redirects) ->
    res = jQuery.parseJSON(res) if typeof(res) == 'string'
    
    Info.show('info', res['info']) if res['info']
    Info.show('info', res['message']) if res['message']
    Info.show('error', res['error']) if res['error']

    location.href = res['redirect_to'] if res['redirect_to'] && follow_redirects
    true
  
  # Info.show('alert', 'Rusi napadaju!')
  # <div id="toast-container" class="toast-top-right"><div class="toast toast-success" style=""><div class="toast-message">Ojlalala 1</div></div></div>
  show: (type, msg) ->
    if type == 'notice' then type = 'info'
    if type == 'alert' then type = 'error'
    el = $('<div class="toast toast-'+type+'" class="toast-top-right"><div class="toast-message">'+msg+'</div></div>')
    cont = $('#toast-container')
    unless cont[0]
      $('body').append('<div id="toast-container" class="toast-bottom-right"></div>')
      cont = $('#toast-container')
    cont.append(el)
    el.css("top", 0)
    setTimeout =>
      el.remove()
    , 4500
  

window.alert = Info.error
