class Main::BucketCell < LuxCell

  def index
    @buckets = Bucket.all.paginate(2)
  end

  def show(id)
    @bucket = Bucket.find(id)
  end

end