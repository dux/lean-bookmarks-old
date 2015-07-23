window.TopModal = 
  render: (title, data) ->
    $(document.body).append """
      <div id="top_modal">
        <div style="position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(100, 100, 100, 0.5) ;z-index:10;"></div>
        <div id="top_modal_panel" style="position:fixed; z-index:11; display:none; top:0; left:50%; width:700px; margin-left:-350px; background-color:#fff; border:1px solid #ccc; padding:20px; border-top:none; border-bottom-right-radius: 4px; border-bottom-left-radius: 4px;">
          <div style="border-bottom:1px solid #ddd; padding-bottom:20px; font-size:120%;">
            <span style="cursor:pointer; float:right; color:#aaa;" onclick="TopModal.close()">&#10006;</span>
            #{title}
          </div>
          <div style="padding-top:20px;">#{data}</div>
        </div>
      </div>
    """

    $('#top_modal_panel').slideDown(100)

  close: ->
    $('#top_modal').remove()

  load: (title, url) ->
    $.get url, (data) ->
      TopModal.render title, data

  app:
    select_bucket: (id) ->
      TopModal.load 'Select bucket', "/bucket/select?id=#{id}"
