class PluginCell < LuxCell

  def self.resolve(path)
    return render(:guest) unless User.current

    base = (path.shift || :index).to_sym;
    return render(base) if [:index, :domain, :recent].index(base)
    
    Error.not_found("Plugin page not found")
  end

  def index
    @link = Link.new :url=>params[:url]
    @domain = Domain.get(@link.domain)
  end

  def domain
    index
  end

end