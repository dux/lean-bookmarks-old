Widget.register 'view-note', 
  init: ->
    @note = JSON.parse @root.innerHTML

  render: ->
    @root.style.display = 'block';

    data = marked(@note.data || '')

    @html """
      <div class="bucket note" href="#{@note.path}">
        <div class="wrap">
          <h4>#{@note.name}</h4>
          #{data}          
        </div>
      </div>
      """

