class Main::LinkCell < LuxCell

  def index
    @links = Link.tagged_with(Lux.params[:suffix])
    @links = @links.where(is_article:true) if params[:art]
    @links = @links.where(is_article:false) if params[:root]
    @links = @links.where(kind:params[:t]) if params[:t] =~ /^\w{3}$/
    @links = @links.paginate(50)
    for el in @links
      el.figure_out_kind
      el.article?
    end
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

  def articles
    @articles = Link.can.is_article.paginate(50)
  end

  def domains
    @domains = Domain.can.paginate(50)
  end

end