class Main::BucketCell < LuxCell

  def index
    @buckets = Bucket.tagged_with(Lux.params[:suffix]).paginate(20)
  end

  def show(id)
    @bucket = Bucket.get(id)
    @top_info = 'Bucket is archived and is not active' unless @bucket.active

    @notes = params[:page].to_i < 2 ? @bucket.notes.limit(50).to_a : []
    @roots = []
    @articles = []
    @images = []
    @videos = []
    @links  = []
    
    @all_links = @bucket.links.paginate(50)

    for el in @all_links
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

    @b_template = 'default'
    @b_template = 'description' if @notes.length < 5 && @bucket.description? 
  end

  def edit(id)
    show(id)
  end

  def archive
    @buckets = Bucket.unscoped.where('active=?', false).paginate(20)
  end

end