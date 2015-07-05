class Main::DomainCell < LuxCell

  def self.resolve(*path)
    return render(:show, path[0])
  end

  def show(name)
    @name = name
    @links  = Link.my.where( domain:name ).paginate(40)
  end

end