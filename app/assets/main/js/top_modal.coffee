window.TopModal = 
  render: (title, data, no_overlay) ->
    overlay = if no_overlay then '' else '<div id="top_modal_overlay" style="position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(100, 100, 100, 0.5) ;z-index:10;" onclick="TopModal.close();"></div>'
    $(document.body).append """
      <div id="top_modal">
        #{overlay}        
        <div id="top_modal_panel" style="position:fixed; z-index:11; display:none; top:0; left:50%; width:700px; margin-left:-350px; background-color:#fff; border:1px solid #ccc; padding:20px; border-top:none; border-bottom-right-radius: 4px; border-bottom-left-radius: 4px;">
          <div style="border-bottom:1px solid #ddd; padding-bottom:20px; font-size:120%;">
            <span style="cursor:pointer; float:right; color:#aaa;" onclick="TopModal.close()">&#10006;</span>
            <span id="top_modal_title">#{title}</span>
          </div>
          <div style="padding-top:20px;" id="top_modal_data">#{data}</div>
        </div>
      </div>
    """

    $('#top_modal_panel').slideDown(100)

  is_visible: ->
    $('#top_modal')[0]

  close: ->
    $('#top_modal').remove()

  load: (title, url, no_overlay) ->
    TopModal.render title, '...', no_overlay
    $.get url, (data) ->
      $('#top_modal_data').html(data)

  respond_click: -> alert('TopModal.respond not binded');

  respond_drop:(ev, id) ->
    link_id = ev.dataTransfer.getData("link_id");
    TopModal.close()
    Api.send "links/#{link_id}/move", bucket_id:id

  app:
    link_bucket_to_bucket: (id, no_overlay=false) ->
      TopModal.respond_click = App.add_bucket_to_bucket
      TopModal.load 'Select bucket', "/bucket/select?id=#{id}", no_overlay

    select_bucket_for_object:(objects, object_id) ->
      TopModal.respond_click = (bucket_id) ->
        TopModal.close();
        Api.post "#{objects}/#{object_id}/update", params:{ bucket_id:bucket_id }, done: Pjax.refresh

      TopModal.load 'Select bucket', "/bucket/select?id=0"




