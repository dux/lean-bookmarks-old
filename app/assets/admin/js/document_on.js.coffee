@DocumentOn =
  func: {}

  refresh: (el, nn)->
    alert 'Find widget and refresh it' 

  click: (el)->
    nn = el[0].nodeName

    return if el.attr('onclick')

    ret = []
    for func in ['confirm', 'form', 'href']
      if DocumentOn.func[func](el, nn)
        ret.push "[#{func}]"
        log "On click: "+ret.join(', ')
        return false
      else
        ret.push func
 
     log "On click: "+ret.join(', ')
     true

  keyup: ->
    $.throttle 'enable_if', 300, ->
      $('*[enable_if]').each ->
        target = $(this)
        if val = target.attr('enable_if')
          target[0].disabled = ! eval val
      


# return true cancels chain
# CLICK handlers
@DocumentOn.func =
  form: (el, nn) ->
    return false unless nn == 'BUTTON'

    form = el.closest('form')
    if form[0]
      el[0].disabled = true
      if aa = form.attr 'api-action'
        $.post "/api/#{aa}", form.serialize(), (response) ->
          el[0].disabled = false
          Info.auto response
          return if response.error
          if done = form.attr('done')
            if done == 'refresh'
              Pjax.load location.href.replace(/https?:\/\/[^\/]+/,'')
            else if done == 'redirect' || done == 'admin'
              Pjax.load "/admin/#{response.class_path}/#{response.data.id}"
            else
              eval done
      else
        location.href = "#{form.attr('action')}?#{form.serialize()}"
        return false
      return true
    else
      false

  # if confirm is found -> validate and return true (cancel execution chain) if confirmed
  confirm: (el, nn) ->
    if c = el.attr('confirm')
      unless confirm(c)
        return true
    false

  # if link is found -> follow and return true, else return false
  href: (el, nn) ->
    if href = el.closest('*[href]').attr('href')
      return if el.attr('target')
      if el.hasClass('no-pjax')
        location.href = href
      else
        Pjax.load href
      return true
    false

$ ->
  $doc = $(document)

  # click
  $doc.on 'click', (event) -> DocumentOn.click $(event.target)

  # keyup
  $doc.on 'keyup', (event) -> DocumentOn.keyup $(event.target)
  $doc.on 'paste', (event) -> DocumentOn.keyup $(event.target)
  $doc.bind 'pjax:get', (event) ->
    DocumentOn.keyup $(event.target)
  # DocumentOn.keyup $(event.target)
