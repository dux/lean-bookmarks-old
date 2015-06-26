$(document).on 'click', (event) ->

  el = $(event.target)

  conf = el.closest('*[confirm]')
  if conf[0]
    return false unless confirm(conf.attr('confirm'))

  test_click = el.closest('*[onclick], *[click]')
  if test_click[0]
    return eval test_click.attr('click') if test_click.attr('click')
    return

  href_el = el.closest('*[href]')

  if href_el[0]
    href = href_el.attr('href')
    return if href_el[0].nodeName == 'A' && href_el.attr('target')

    return true if event.which == 2
  
    javascript = href.split('javascript:')
    if javascript[1]
      eval javascript[1].replace(/([^\w])this([^\w])/g,'\\$1href_el\\$2')
      return false

    if href_el.hasClass('no-pjax') || href_el.hasClass('direct')
      location.href = href
      return false
    else
      # if it is in modal-box and has IncludeWidget info inside
      if href_el.closest('widget')[0] && href_el.closest('#big-modal-data')[0]
        IncludeWidget.load(href_el, href)
        return false
      else
        Pjax.load(href)
        return false

