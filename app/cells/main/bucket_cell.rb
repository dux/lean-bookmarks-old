class Main::BucketCell < LuxCell

  def index
    @buckets = Bucket.tagged_with(Lux.params[:suffix]).paginate(20)
  end

  def show(id)
    @bucket = Bucket.get(id)
    @top_info = 'Bucket is archived and is not active' unless @bucket.active

    @notes = @bucket.notes.to_a
    @roots = []
    @articles = []
    @images = []
    @videos = []
    @links  = []
    for el in @bucket.links
      if el.kind == 'vid'
        @videos.push el
      elsif el.kind == 'img'
        @images.push el
      elsif el.kind == 'doc'
        @notes.push el
      elsif el.is_article?
        @articles.push el
      else
        @links.push el
      end
    end
  end

  def edit(id)
    show(id)
  end

  def archive
    @buckets = Bucket.unscoped.where('active=?', false).paginate(20)
  end

end