class BucketApi < LuxApi

  def index
    Bucket.select('id,name').can.paginate(50).map(&:attributes)
  end

  def create
    if exists = Bucket.my.where(name:params[:name]).first
      @message = "You allready have bucket with that name"
      return exists
    end

    super
  end

  def add_bucket
    bucket = Bucket.get params[:id]
    return 'Bucket is allready in collection' if @bucket[:child_buckets].index(bucket.id)
    raise 'Bucket is same as parent' if @bucket.id == bucket.id
    @bucket[:child_buckets].push bucket.id
    @bucket.save!
    'Bucket added to bucket collection'
  end

  def remove_bucket
    bucket = Bucket.get params[:id]
    return 'Bucket is not in collection' unless @bucket[:child_buckets].index(bucket.id)
    @bucket[:child_buckets] -= [bucket.id]
    @bucket.save!
    'Bucket removed from collection'
  end

  def add_object
    name = params[:name]    

    raise 'Name to short' unless name.to_s.length > 1

    if name =~ /https?:\/\//
      l = Link.new
      l.url = name
      l.bucket_id = @bucket.id
      l.fetch_name
      l.save!
      l.bucket.touch
      return 'Link in bucket added'
    else
      b = Note.new
      b.name = name
      b.bucket_id = @bucket.id
      b.save!
      return 'Note created'
    end

  end

end