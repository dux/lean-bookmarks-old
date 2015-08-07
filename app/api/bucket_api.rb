class BucketApi < LuxApi

  def index
    Bucket.select('id,name').can.paginate(50).map(&:attributes)
  end

  def create
    name = params[:name]    
    raise "Name or link is required" unless name.present?

    if name =~ /https?:\/\//
      if params[:bucket_id]
        raise 'Link is present in a bucket' if Link.where(:bucket_id=>params[:bucket_id], :url=>name).first

        l = Link.new
        l.url = name
        l.bucket_id = params[:bucket_id]
        l.fetch_name
        l.save!
        return 'Link in bucket added'
      else
        raise 'Bucket ID not present'
      end
    else
      b = Bucket.new
      b.name = name
      b.save!
      return 'Bucket created'
    end
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