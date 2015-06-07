global_submit_form = (form) ->
  if (form.attr('method') || 'get').toUpperCase() == 'GET'
    action = form.attr('action') || location.href
    Pjax.load "#{action}?#{form.serialize()}"
    return false

  if aa = form.attr 'api-action'
    # firefox makes double requests on form posting? leave this.
    return false if window.last_api_action == aa
    window.last_api_action = aa
    setTimeout (->
      window.last_api_action = null
      return
    ), 400

    $.post "/api/#{aa}", form.serialize(), (response) ->
      Info.auto response
      window.disabled_button.disabled = false if window.disabled_button
      return false if response.error
      if done = form.attr('done')
        if done == 'refresh'
          Pjax.load location.href.replace(/https?:\/\/[^\/]+/,'')
          Popup.close() if window.Popup
        else if done == 'redirect'
          Pjax.load response.path
          Popup.close() if window.Popup
        else if /^\//.test(done)
          Pjax.load done
          Popup.close() if window.Popup
        else
          eval done
        return false
      return false
  return false

$(document).on 'click', (event) ->
  el = $(event.target)

  conf = el.closest('*[confirm]')
  if conf[0]
    return false unless confirm(conf.attr('confirm'))

  test_click = el.closest('*[onclick], *[click]')
  if test_click[0]
    return eval test_click.attr('click') if test_click.attr('click')
    return
  
  button = el.closest('button')
  if button[0]
    form = el.closest('form')
    if form[0]
      return if el.closest('.note-editor')[0]
      return if form.attr('onsubmit')
      global_submit_form(form)
      window.disabled_button = button[0]
      button[0].disabled = true
      setTimeout ->
        window.disabled_button.disabled = false
      , 2000

  href_el = el.closest('*[href]')
  if href_el[0]
    href = href_el.attr('href')
    return if href_el[0].nodeName == 'A' && href_el.attr('target')
  
    return true if event.which == 2
  
    if el.hasClass('new')
      window.open(href)
      return false
    javascript = href.split('javascript:')
    if javascript[1]
      eval javascript[1].replace(/([^\w])this([^\w])/g,'\\$1href_el\\$2')
      return false
    if /https?:\/\//.test(href) || href_el.attr('target')
      window.open href, href_el.attr('target')
      return false
    if href_el.hasClass('no-pjax') || href_el.hasClass('direct')
      location.href = href
    else
      # if it is in modal-box and has IncludeWidget info inside
      if href_el.closest('widget')[0] && href_el.closest('#big-modal-data')[0]
        IncludeWidget.load(href_el, href)
        return false
      else
        Pjax.load(href)


$(document).on 'submit', 'form', -> global_submit_form($(this))


