class Main::UserCell < LuxCell

  # def self.get(*args)
  #   what = args.first
  #   return get :random if what == 'random'
  #   return render :index unless what
  #   return render :show, what.to_i
  # end

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

  def login

  end

  def set_password
    if hash = Lux.params[:user_hash]
      usr_email = Crypt.decrypt(hash)
      usr = User.quick_create(usr_email)
      Lux.request.session[:u_id] = usr.id
      Lux.redirect Lux.request.path
    end
  end

  def bye
    Lux.session.delete(:u_id)
    Lux.flash :info, 'Bye bye'
    Lux.redirect '/'
  end


end
