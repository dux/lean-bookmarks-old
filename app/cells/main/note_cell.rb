class Main::NoteCell < LuxCell

  def index
    @notes = Note.all
  end

  def show
    @note = Note.find(params[:id]).can
  end

end