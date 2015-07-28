class PluginCell < LuxCell

  template :recent, :guest

  def self.resolve(*path)
    unless User.current
      return render(:guest)
    end

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