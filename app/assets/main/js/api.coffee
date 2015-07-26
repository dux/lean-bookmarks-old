# Api.bucket.destroy(this, 12)

@Api = 
  # Api.post('/users/list', { p:{city:'Zagreb'}, silent:true })
  post: (method, opts={}) ->
    if opts.done
      if opts.done == 'refresh'
        opts.done = -> Pjax.refresh() 

      if opts.done == 'redirect'
        opts.done = (data) -> Pjax.load(data.path)

      if /^\//.test(opts.done)
        opts.done = -> Pjax.load(opts.done) 

    opts.params = opts.p if opts.p
    opts.params ||= {}
    opts.params = $(opts.params).serializeHash() if opts.params?.getAttribute

    opts.silent ||= false

    if opts.disable
      $(opts.disable).disable()

    for key in Object.keys(opts)
      alert "Unknown attribute [#{key}] in Api.post opts" if ['p','params','silent','done'].indexOf(key) == -1

    method = "/api/#{method}" unless /^\/api/.test(method)

    $.post method, opts.params, (ret) ->
      Info.auto(ret) unless opts['silent']
      opts['done'](ret) if opts['done'] && ! ret['error']


  silent: (method, opts, func) ->
    if typeof(opts) == 'function'
      func = opts
      opts = {}

    Api.post(method, { p:opts, silent:true, done:func })


  send: (method, opts, func) ->
    if typeof(opts) == 'function'
      func = opts
      opts = {}

    Api.post(method, { p:opts, done:func })

