class AppApi < LuxApi

  action :toggle_tag do
    name 'Toggle tag on a link'
    params :tag, :string, :req
    lambda do
      tag = params[:tag].to_s.downcase
      if @object.tags.index(tag)
        @object[:tags] -= [tag]
        @message = 'Removed from collection'
      else
        @object[:tags] += [tag]
        @message = 'Added to collection'
      end
      @object.save
      @response[:present] = true if @object.tags.index(tag)
      @object
    end
  end

end