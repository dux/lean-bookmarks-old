window.TextAreaEditor = 
  help: """
    <p><b>**dupli znak množenja za bold**</b></p>
    <p><i>*znak množenja za italic*</i></p>
    <ul>
      <li>* za list item 1</li>
      <li>* za list item 2</li>
    </ul>
    <ol>
      <li>za list item 1</li>
      <li>za list item 2</li>
    </ol>
    <p><button class="btn btn-default btn-xs" onclick="window.open('https://guides.github.com/features/mastering-markdown/'); return false;">više</button></p>
 """

  getSelection: (e) ->
    (("selectionStart" of e and ->
      l = e.selectionEnd - e.selectionStart
      start: e.selectionStart
      end: e.selectionEnd
      length: l
      text: e.value.substr(e.selectionStart, l)
    ) or (document.selection and ->
      e.focus()
      r = document.selection.createRange()
      if r is null
        return (
          start: 0
          end: e.value.length
          length: 0
        )
      re = e.createTextRange()
      rc = re.duplicate()
      re.moveToBookmark r.getBookmark()
      rc.setEndPoint "EndToStart", re
      start: rc.text.length
      end: rc.text.length + r.text.length
      length: r.text.length
      text: r.text
    
    # browser not supported 
    ) or ->
      null
    )()

  getInputSelection: (el) ->
    start = 0
    end = 0
    normalizedValue = undefined
    range = undefined
    textInputRange = undefined
    len = undefined
    endRange = undefined
    if typeof el.selectionStart is "number" and typeof el.selectionEnd is "number"
      start = el.selectionStart
      end = el.selectionEnd
    else
      range = document.selection.createRange()
      if range and range.parentElement() is el
        len = el.value.length
        normalizedValue = el.value.replace(/\r\n/g, "\n")

        # Create a working TextRange that lives only in the input
        textInputRange = el.createTextRange()
        textInputRange.moveToBookmark range.getBookmark()
        
        # Check if the start and end of the selection are at the very end
        # of the input, since moveStart/moveEnd doesn't return what we want
        # in those cases
        endRange = el.createTextRange()
        endRange.collapse false
        if textInputRange.compareEndPoints("StartToEnd", endRange) > -1
          start = end = len
        else
          start = -textInputRange.moveStart("character", -len)
          start += normalizedValue.slice(0, start).split("\n").length - 1
          if textInputRange.compareEndPoints("EndToEnd", endRange) > -1
            end = len
          else
            end = -textInputRange.moveEnd("character", -len)
            end += normalizedValue.slice(0, end).split("\n").length - 1
    start: start
    end: end
  
  replaceSelection: (el, text) ->
    sel = TextAreaEditor.getInputSelection(el)
    val = el.value
    el.value = val.slice(0, sel.start) + text + val.slice(sel.end)
    return

  bold: (ta, tag) ->
    data = TextAreaEditor.getSelection(ta)
    return unless data.text
    # data = data.text.replace(/(\w+)/g,"**$1**")
    TextAreaEditor.replaceSelection(ta, "**#{data.text}**")

  italic: (ta, tag) ->
    data = TextAreaEditor.getSelection(ta)
    return unless data.text
    data = data.text.replace(/(\w+)/g,"*$1*")
    TextAreaEditor.replaceSelection(ta, data)

  ul: (ta, tag) ->
    data = TextAreaEditor.getSelection(ta)
    return unless data.text
    TextAreaEditor.replaceSelection(ta, "\n* #{data.text}\n")

class window.EditorWidget extends Widget
  init: ->
    id = @root.attr('id')
    @root.before """<div style="margin-bottom:5px;">
      <button class="btn btn-default btn-xs" onclick="TextAreaEditor.bold($('##{id}')[0]); return false"><b>bold</b></button>
      <button class="btn btn-default btn-xs" onclick="TextAreaEditor.italic($('##{id}')[0]); return false"><i>italic</i></button>
      <button class="btn btn-default btn-xs" onclick="TextAreaEditor.ul($('##{id}')[0]); return false">&bull; list item</button>
      <button class="btn btn-info btn-xs" onclick="Popup.render(this, 'Markdown help', TextAreaEditor.help); return false">HELP</button>
    </div>"""






