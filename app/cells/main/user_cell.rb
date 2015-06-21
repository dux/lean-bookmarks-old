class Main::UserCell < LuxCell

  template :login, :profile

  def show(id)
    @user = User.find(id)
  end

  def random!
    id = (1..10).to_a.sample
    render(:show, id)
  end

  def index
    @users = User.all
  end

  def bye
    Lux.session.delete(:u_id)
    Lux.flash :info, 'Bye bye'
    Lux.redirect '/'
  end

end
