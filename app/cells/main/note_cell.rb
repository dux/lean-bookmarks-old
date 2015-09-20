class Main::NoteCell < LuxCell

  def index
    @notes = Note.can.tagged_with(Page.params[:suffix]).paginate(20)
    # @w_notes = []
    # @notes.each do |el|
    #   @w_notes.push( path: el.path, name: el.name, data: el.data.to_s )
    # end
  end

  def show(id)
    @Object = @note = Note.get(id)
    @top_info = 'Note is archived and is not active' unless @note.active
  end

  def archive
    @notes = Note.unscoped.order('updated_at desc').my.where('active=?', false).paginate(30)
  end

end