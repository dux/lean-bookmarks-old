class Main::NoteCell < Main::RootCell

  def index
    @notes = Note.my.tagged_with(Lux.params[:suffix]).paginate(20)
  end

  def show(id)
    @note = Note.get(id)
    @top_info = 'Note is archived and is not active' unless @note.active
  end

  def edit(id)
    show(id)
  end

  def archive
    @notes = Note.unscoped.order('updated_at desc').my.where('active=?', false).paginate(30)
  end

end