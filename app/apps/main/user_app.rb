module Main
  class UserApp < MasterApp

    def self.router(*args)
      what = args.first
      return get :random if what == 'random'
      return render :index unless what
      return render :show, what.to_i
    end

    def show(id)
      @user = User.find(id)
    end

    def random
      sinatra.headers({ 'X-Test'=>"123456789" })
    
      id = (1..10).to_a.sample
      self.class.render(:show, id)
    end

    def index
      @users = User.all
    end

  end

end
