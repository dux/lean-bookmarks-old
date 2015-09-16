class Main::StaticCell < LuxCell

  def search
    @notes  = Note.can.like(Page.params[:q], :name, :data).limit(8)
    @links  = Link.can.like(Page.params[:q], :name, :description, :url).limit(8)
    @buckets = Bucket.can.like(Page.params[:q], :name, :description).limit(8)

    @all_links = [@notes, @links, @buckets].flatten.compact.sort{ |a,b| a.updated_at <=> b.updated_at }

    @template = 'main/search'
  end

end 