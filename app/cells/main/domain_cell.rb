class Main::DomainCell < LuxCell

  def self.resolve(*path)
    return render(:index) unless path[0]
    return render(:show, path[0])
  end

  def show(name)
    @name = name
    @links  = Link.my.where( domain:name ).paginate(40)
    @domain = Domain.get(name)
  end

  def index
    @domains = Domain.my.paginate(50)
  end

end