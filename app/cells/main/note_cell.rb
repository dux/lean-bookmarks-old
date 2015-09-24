class Main::NoteCell < LuxCell

  def index
    return if Page.etag Note.my_last_updated

    @notes = Note.can.tagged_with(Page.params[:suffix]).paginate(20)
  end

  def show(id)
    @Object = @note = Note.get(id)
    @top_info = 'Note is archived and is not active' unless @note.active
  end

  def archive
    @notes = Note.unscoped.order('updated_at desc').my.where('active=?', false).paginate(30)
  end

end