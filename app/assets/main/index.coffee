#= req js/*
#= req ../components/toastr/toastr.coffee

$ ->
  Pjax.init('#full-page')
  
  Pjax.on_get ->
    $('a[href]').click -> Pjax.load(this)

  Pjax.on_get()


