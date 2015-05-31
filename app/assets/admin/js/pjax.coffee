@Pjax =
  skip_on: [],
  push_state: false,
  load_is_safe: false,
  refresh: (func) -> Pjax.load(location.pathname+location.search, { func:func })  

  init: (@full_page=false) ->
    return alert "#full_page ID referece not defined in PJAX!\n\nWrap whole page in one DIV element" unless @full_page

    if window.history && window.history.pushState
      Pjax.push_state = true

      # u chrome se automatski trigerrira popstate na kraju page rendera, i evo ti novog requesta. disable 1sec pjax load
      setTimeout ->
        Pjax.load_is_safe = true
      , 1000

      window.onpopstate = (event, href) ->
        if event.state && event.state.body
          console.log "Pjax.load (back trigger, cache hit)s: #{event.state.href}"
          if /<form/.test(event.state.body)
            Pjax.load(event.state.href, history:true);
          else
            Pjax.replace event.state.title, event.state.body
        else
          Pjax.load(levent.state.href, history:true);
        
        $(document).trigger 'pjax:get'

      $(window).trigger('page:change')

  skip: ->
    for el in arguments
      Pjax.skip_on.push el

  redirect: (href) ->
    location.href = href
    false

  replace: (title, body) ->
    document.title = title
    $(@full_page).html body
    $(window).trigger('page:change')

  load: (href, opts={}) ->

    return false unless Pjax.load_is_safe
    return false unless href

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
      
      $(document).trigger 'pjax:get'

      unless opts['history']
        if href == location.href 
          window.history.replaceState({ body:body, href:href, title:document.title}, document.title, href)
        else
          window.history.pushState({ body:body, href:href, title:document.title}, document.title, href)

      # Google Analytics support
      _gaq.push ['_trackPageview'] if window._gaq

      opts.func() if opts.func

      window.scrollTo(0, 0)

    ).error (ret) ->
      Info.error ret.statusText

    false
