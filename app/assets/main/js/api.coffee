# Api.bucket.destroy(this, 12)

@Api = 
  silent: (method, opts, func) ->
    if typeof(opts) == 'function'
      func = opts
      opts = {}

    method = "/api/#{method}" unless /^\/api/.test(method)
    $.post method, opts, (ret) ->
      func(ret) if func && ! ret['error']

  send: (method, opts, func) ->
    if typeof(opts) == 'object'
      opts = $(opts).serializeHash()

    if typeof(opts) == 'function'
      func = opts
      opts = {}
    
    method = "/api/#{method}" unless /^\/api/.test(method)
    
    $.post method, opts, (ret) ->
      Info.auto(ret)
      func(ret) if func && ! ret['error']


  # Api.rails_form(button inside form)
  rails_form: (node, on_success) ->
    node = $ node
    node.find('button').each ->
      $(this).disable('Saveing...', 2000)
    form = node.closest('form')
    for key, val of form.serializeHash()
      if is_.o val
        Api.send form.attr('action'), val, on_success
    false


