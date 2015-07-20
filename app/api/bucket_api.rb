   class BucketApi < LuxApi

  def index
    Bucket.select('id,name').can.paginate(50).map(&:attributes)
  end

  def create
    name = params[:name]    
    raise "Name or link is required" unless name.present?

    if name =~ /https?:\/\//
      if params[:bucket_id]
        raise 'Link is present in a bucket' if Link.where(:bucket_id=>params[:bucket_id]).first

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

end