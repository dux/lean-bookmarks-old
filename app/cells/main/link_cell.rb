class Main::LinkCell < LuxCell

  def index
    @links = Link.tagged_with(Lux.params[:suffix]).paginate(50)
  end

  def archive
    @links = Link.unscoped.order('updated_at desc').my.where('active=?', false).paginate(50)
  end

  def show(id)
    @link = Link.get(id)
    @top_info = 'Link is archived and is not active' unless @link.active
  end

  def edit(id)
    show(id)
  end

end