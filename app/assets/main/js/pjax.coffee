# Pjax.init('#full-page')

# Pjax.on_get ->
#   $('a[href]').click -> Pjax.load(this)

# Pjax.on_get()


@Pjax =
  skip_on: [],
  push_state: false,
  refresh: (func) -> Pjax.load(location.pathname+location.search, { done:func })  

  init: (@full_page=false) ->
    return alert "#full_page ID referece not defined in PJAX!\n\nWrap whole page in one DIV element" unless @full_page

    if window.history && window.history.pushState
      Pjax.push_state = true
      window.history.pushState({ href:location.href, type:'init' }, document.title, location.href)

      window.onpopstate = (event) ->
        console.log event.state
        if event.state && event.state.href
          Pjax.load(event.state.href, history:true);
        else
          history.go(-2)

  skip: ->
    for el in arguments
      Pjax.skip_on.push el

  redirect: (href) ->
    location.href = href
    false

  replace: (title, body) ->
    document.title = title
    $(@full_page).html body
    $(document).trigger('page:change')

  load: (href, opts={}) ->
    return false unless href

    href = $(href).attr('href') if typeof href == 'object'

    return if href == '#'
    return @redirect(href) if /^http/.test(href)
    return @redirect(href) if /#/.test(href)
    return @redirect(href) unless Pjax.push_state

    for el in Pjax.skip_on
      switch typeof el
        when 'object' then return @redirect(href) if el.test(href)
        when 'function' then return @redirect(href) if el(href)
        else return @redirect(href) if el == href

    speed = $.now()
    $.get(href).done( (data) =>
      console.log "Pjax.load #{if opts.history then '(back trigger)' else ''} #{$.now()-speed}ms: #{href}"
      obj = $ "<div>#{data}</div>"
      body = obj.find(@full_page).html() || data

      Pjax.replace obj.find('title').first().html(), body

      unless opts['history']
        if location.href.indexOf(href) > -1
          window.history.replaceState({ href:href, type:'replaced' }, document.title, href)
        else
          window.history.pushState({ href:href, type:'pushed' }, document.title, href)

      # Google Analytics support
      ga('send', 'pageview') if window.ga;

      opts.done() if opts.done

      # window.scrollTo(0, 0)

    ).error (ret) ->
      Info.error ret.statusText

    false

  on_get: (func) ->
    if func
      $(document).on 'page:change', -> func()
    else
      $(document).trigger 'page:change'

