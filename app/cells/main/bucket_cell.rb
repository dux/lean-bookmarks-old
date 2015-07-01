class Main::BucketCell < LuxCell

  def index
    @buckets = Bucket.tagged_with(Lux.params[:suffix]).paginate(20)
  end

  def show(id)
    @bucket = Bucket.get(id)
    @top_info = 'Bucket is archived and is not active' unless @bucket.active
  end

  def edit(id)
    show(id)
  end

  def archive
    @buckets = Bucket.unscoped.where('active=?', false).paginate(20)
  end

end