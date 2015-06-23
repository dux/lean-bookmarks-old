#= req js/*
#= req ../components/toastr/toastr.coffee

$ ->
  Pjax.init('#full-page')
  
  Pjax.on_get ->
    $('a[href]').click -> Pjax.load(this)
    Popup.close()

  Pjax.on_get()


window.delete_object = (object, id) ->
  return unless confirm 'Are you shure?'
  Api.send "#{object}/#{id}/destroy", {}, -> Pjax.load("/#{object}")


window.restore_object = (object, id) ->
  Api.send "#{object}/#{id}/undelete", {}, (data) -> Pjax.load(data.path)


Popup.go = 
  clients: (button, org_id, on_click) ->
    Popup.render button, 'Izaberite klijenta', '...'
    window.modal_click_target = on_click
    data = """<div style="width:350px;">
        <input type="text" placeholder="traži" onkeyup="$w('#c_in_t').set('q', this.value)" class="form-control" style="width:150px; display:inline-block;" />
        <a class="btn btn-default fr" href="/orgs/#{org_id}/new_client">+ novi klijent</a>
      </div>
      <div id="c_in_t" class="widget clients_in_table" org="#{org_id}" style="max-height:400px;overflow:auto;"></div>"""
    Popup.data data

  form: (button, title, url, name, value, opts={}) ->
    form = """<input type="text" class="form-control" name="#{name}" value="#{value}" style="width:250px;" id="popup_input" />"""

    if opts['as'] == 'editor'
      form = """<div style="width:500px;"><textarea id="popup_editor" class="widget editor form-control" name="#{name}" style="width:100%; height:150px;">#{value}</textarea></div><br>"""

    form = """<form onsubmit="_t=this; Api.send('#{url}', this, function(){ Pjax.refresh(true); }); return false;" method="post">#{form}<button class="btn btn-primary" style="float:right;">Create</button></form>"""

    Popup.render button, title, form

    init_html_editor() if opts['as'] == 'editor'


