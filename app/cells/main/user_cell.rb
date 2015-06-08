class Main::UserCell < LuxCell

  # def self.get(*args)
  #   what = args.first
  #   return get :random if what == 'random'
  #   return render :index unless what
  #   return render :show, what.to_i
  # end

  def show(id)
    
    mail = Mail.new do
      from    'Dux <reic.dino@gamil.com>'
      to      'rejotl@gmail.com'
      subject 'MAil in sinatre'
      body    'I ovo smo uspjeli'
    end

    # mail.deliver!


    @user = User.find(id)
  end

  def random!
    sinatra.headers({ 'X-Test'=>"123456789" })
  
    id = (1..10).to_a.sample
    render(:show, id)
  end

  def index
    @users = User.all
  end

  def comments!(id)
    'nice'
  end

  def login

  end

end
