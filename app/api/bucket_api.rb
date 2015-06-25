class BucketApi < LuxApi

  def index
    Bucket.select('id,name').can.paginate(50).map(&:attributes)
  end

end