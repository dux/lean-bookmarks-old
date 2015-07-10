#= require_tree ./js

$.extend
  cachedScript: (url, options) ->
    if typeof(options) == "function"
      options = 
        success:options

    options = $.extend options or {},
      dataType: "script"
      cache: true
      url: url
    
    jQuery.ajax options

  throttle: (id, ms, func) ->
    window.throttle ||= {}
    clearTimeout window.throttle[id] if window.throttle[id]
    window.throttle[id] = setTimeout ->
     console.log  "$.throttle FIRE #{id}, #{ms}ms"
     func()
    , ms


@log = (what) ->
  if window.console then console.log(what) else false

@Rails = 
  delete: (what, id, url) ->
    return false unless confirm 'Shure ?'
    $.post "/api/#{what}/#{id}/destroy",'', (response) ->
      Info.auto response
      unless response.error
        url ||= "/admin/#{what}"
        Pjax.load url

  update: (what, id, opts) ->
    $.post "/api/#{what}/#{id}/update",opts, (response) ->
      Info.auto response

  api: (url, opts, func) ->
    $.post "/api/#{url}", opts, (response) ->
      Info.auto response
      func() if func

$ ->
  $.cachedScript 'http://api.filepicker.io/v1/filepicker.js', 
    -> filepicker.setKey('Ad2YNAorRgmFCY1XphLPgz');

  # window.alert = Info.alert
  Pjax.init '#full_page'
  Pjax.skip (el) -> ! /\/admin\//.test(el)

