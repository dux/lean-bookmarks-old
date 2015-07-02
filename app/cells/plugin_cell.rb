class PluginCell < LuxCell

  def self.resolve(*path)
    base = (path.shift || :index).to_sym;
    return render(base) if [:index, :domain, :recent].index(base)
    return Lux.status :not_found, "Plugin page not found"
  end

  def index
    @link = Link.new :url=>params[:url]
    @domain = Domain.my.where(:name=>@link.domain).first || Domain.new
  end

  def domain
    index
  end

  def recent
    
  end

end