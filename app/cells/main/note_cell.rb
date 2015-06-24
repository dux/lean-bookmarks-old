class Main::NoteCell < LuxCell

  def index
    @notes = Note.my.paginate(20)
  end

  def show(id)
    @note = Note.get(id)
  end

  def archive
    @notes = Note.unscoped.order('updated_at desc').my.where('active=?', false).paginate(30)
  end

end