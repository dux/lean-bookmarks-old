@Template = 
  render:(name) ->
    data = window.DATA[name]
    ret = []
    for el in data
      ret.push """<tr>
        <td><a href="#{el.domain}"></a></td>
        <td>
          <a href="#{el.url}" target="_new"><img src="#{el.thumbnail}" style="width:150px; height:112px; border:1px solid #ccc;" /></a>
        </td>
        <td>
          <b>#{el.as_link}</b>
          <br />
          <p><small><a href="#{el.url}">#{el.url}</a></small></p>
          <small class="gray">#{el.ago} | <a href="/domain/#{el.domain}">#{el.domain}</a> | #{el.bucket}</small>
          <p class="desc" style="margin-top:10px;">#{el.description}</p>
        </td>
      </tr>"""

    $('#'+name).html("""<table class="table">#{ret.join('')}</table>""")
