#= req js/*

$ ->
  Pjax.init('#full-page')
  
  Pjax.on_get ->
    $('a[href]').click -> Pjax.load(this)

  Pjax.on_get()

