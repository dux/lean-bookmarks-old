class LinkApi < LuxApi

  def create
    raise 'Not a link' unless params[:url] =~ /https?:\/\//

    if params[:bucket_id]
      b = Bucket.find(params[:bucket_id]).can
    else
      params[:bucket_id] = Bucket.unsorted_bucket.id
    end

    if b = Link.my.where( bucket_id:params[:bucket_id], url:params[:url] ).first
      respond 'You allready added this bookmark' 
      return b
    end

    bm = Link.new(:url=>params[:url], :name=>params[:name], :description=>params[:description], :tags=>params[:tags], :bucket_id=>params[:bucket_id])
    bm.fetch_name unless bm.name?
    bm.tags = [params[:tag]] if params[:tag]
    bm.save!
    @message = 'Bookmark added'
    bm
  end

  def toggle_tag
    tag = params[:tag].to_s.downcase
    if @bookmark.tags.index(tag)
      @bookmark.tags -= [tag]
      @message = 'Tag removed from collection'
    else
      @bookmark.tags += [tag]
      @message = 'Tag added to collection'
    end
    @bookmark.save
  end

  def get_title
    bm = Link.new :url=>params[:url], :name=>params[:name]
    bm.fetch_name unless bm.name?
    @message = 'Fetched title'
    { name:bm.name, description:bm.description }
  end

end