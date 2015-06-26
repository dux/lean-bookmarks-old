class Main::BucketCell < LuxCell

  def index
    @buckets = Bucket.tagged_with(Lux.params[:suffix]).paginate(20)
  end

  def _load(id)
    @bucket = Bucket.get(id)
    @top_info = 'Bucket is archived and is not active' unless @bucket.active
  end

  def show(id)
    _load(id)
  end

  def edit(id)
    _load(id)
  end

  def archive
    @buckets = Bucket.unscoped.where('active=?', false).paginate(20)
  end

end