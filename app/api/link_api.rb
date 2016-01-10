class LinkApi < AppApi

  def create
    raise 'Not a link' unless params[:url] =~ /https?:\/\//

    if params[:bucket_id]
      b = Bucket.find(params[:bucket_id]).can
    else
      params[:bucket_id] = Bucket.unsorted_bucket.id
    end

    if l = Link.my.where( bucket_id:params[:bucket_id], url:params[:url] ).first
      @message = "You allready added this link in bucket #{l.bucket.name}"
      return l
    end

    bm = Link.new(:url=>params[:url], :name=>params[:name], :description=>params[:description], :tags=>params[:tags], :bucket_id=>params[:bucket_id])
    bm.tags = [params[:tag]] if params[:tag]
    bm.save!
    bm.bucket.touch
    @message = 'Link added'
    bm
  end

  def get_title
    bm = Link.new :url=>params[:url], :name=>params[:name]
    bm.fetch_name unless bm.name?
    @message = 'Fetched title'
    { name:bm.name, description:bm.description }
  end

  def move
    old_bucket_name = @link.bucket.name
    @link.update bucket_id:params[:bucket_id]
    %[Link moved from bucket "#{old_bucket_name}" to bucket "#{@link.bucket.name}"]
  end

  def index2
    Link.all
  end

  def refresh
    @link.fill_missing_data
    @link.save
    @message = 'ok'
    @link.attributes
  end

end