# Model.bucket(12).destroy();
# Model.bucket().create({ name:'Test' }, function(){ });

# Api.post('/users/list', { p:{city:'Zagreb'}, silent:true })
# Api.post('/users/list', { p:{city:'Zagreb'}, silent:true })
# Api.post('users/sel_db?id=1', { load:'/' })
# Api.post('users/sel_db?id=1', { done:'refresh' })
# Api.post('notes/create', { params:{ name:'Test' }, done:'redirect' })

@Api =
  post: (method, opts={}) ->
    if opts.done
      if opts.done == 'refresh'
        opts.done = -> Pjax.refresh() 

      if opts.done == 'redirect'
        opts.done = (data) -> Pjax.load(data.path)

      if typeof(opts.done) == 'string' && /\//.test(opts.done)
        opts.load = opts.done

      if opts.load
        opts.done = ->
          Pjax.load(opts.load)

    if opts.form
      opts.params ||= $(opts.form).serializeHash()
      _disable_button = $(opts.form).find('*[disable-with]')
      if _disable_button[0]
        _disable_button.data('html-data', _disable_button.html())
        _disable_button.html(_disable_button.attr('disable-with')+'...')
        _disable_button.prop('disabled', true)

    opts.params ||= {}
    opts.params = $(opts.params).serializeHash() if opts.params?.getAttribute

    opts.silent ||= false

    if opts.disable
      $(opts.disable).disable()

    for key in Object.keys(opts)
      alert "Unknown attribute [#{key}] in Api.post opts" if ['params','silent','done','load', 'form'].indexOf(key) == -1

    method = "/api/#{method}" unless /^\/api/.test(method)

    $.post method, opts.params, (ret) ->
      Info.auto(ret) unless opts['silent']

      opts['done'](ret) if opts['done'] && ! ret['error']

      if _disable_button
        _disable_button.html(_disable_button.data('html-data'))
        _disable_button.prop('disabled', false)


  silent: (method, opts, func) ->
    if typeof(opts) == 'function'
      func = opts
      opts = {}

    Api.post(method, { params:opts, done:func, silent:true })


  send: (method, opts, func) ->
    if typeof(opts) == 'function'
      func = opts
      opts = {}

    Api.post(method, { params:opts, done:func })
