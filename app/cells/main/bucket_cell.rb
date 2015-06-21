class Main::BucketCell < LuxCell

  def index
    @buckets = Bucket.all
  end

  def show(id)
    @bucket = Bucket.find(id)
  end

end