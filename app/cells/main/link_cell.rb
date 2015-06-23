class Main::LinkCell < LuxCell

  def index
    @links = Link.paginate(50)
  end

  def archive
    @links = Link.unscoped.order('updated_at desc').my.where('active=?', false).paginate(50)
  end

  def show(id)
    @link = Link.get(id)
  end

end