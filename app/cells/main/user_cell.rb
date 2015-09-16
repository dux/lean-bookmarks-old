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
    Page.session.delete(:u_id)
    Page.flash :info, 'Bye bye'
    Page.redirect '/'
  end

end
