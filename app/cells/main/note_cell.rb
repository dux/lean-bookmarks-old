class Main::NoteCell < LuxCell

  def index
    @notes = Note.my.paginate(20)
  end

  def show(id)
    @note = Note.get(id)
  end

end