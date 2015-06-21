class LinkApi < LuxApi

  def create
    if b = Link.my.where( url:params[:url] ).first
      respond 'You allready added this bookmark' 
      return b
    end
    raise 'Not a link' unless params[:url] =~ /https?:\/\//

    bm = Link.new :url=>params[:url], :name=>params[:name], :description=>params[:description], :tags=>params[:tags]
    bm.fetch_name unless bm.name?
    bm.tags = [params[:tag]] if params[:tag]
    bm.save!
    respond 'Bookmark added'
    bm
  end

  def toggle_tag
    tag = params[:tag].to_s.downcase
    if @bookmark.tags.index(tag)
      @bookmark.tags -= [tag]
      respond 'Tag removed from collection'
    else
      @bookmark.tags += [tag]
      respond 'Tag added to collection'
    end
    @bookmark.save
  end

  def get_title
    bm = Link.new :url=>params[:url], :name=>params[:name]
    bm.fetch_name unless bm.name?
    respond 'Fetched title'
    { name:bm.name, description:bm.description }
  end

end