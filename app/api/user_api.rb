class UserApi < LuxApi

  action :show do
    name 'Show single user based on email'
    params :email, :email
    lambda do
      @error = {}
      @message = 'all good for now'
      return User.where(email:params[:email]).first.attributes if params[:email]
      return User.find(params[:_id]).attributes if params[:_id]
      'What to find on?'
    end
  end

  inline_action :index do
    User.order('users.id asc').select('id, email, name')#.limit(3).offset(3)
  end

  action :login do
    name 'Login via email and pass'
    params :email, :email, :req
    params :pass, :req
    lambda do
      usr = User.login(@_email, @_pass)
      raise 'User not found, bad passord or email' unless usr
      Lux.session[:u_id] = usr.id
      'Login ok'
    end
  end

  action :signup do
    name 'Signup via email to app'
    params :email, :email, :req
    lambda do
      Mailer.confirm_email(@_email).deliver
      'Confirmation email sent'
    end
  end

  action :set_password do
    name 'Confirm email'
    params :pass, :req
    params :pass_confirm, :req
    lambda do
      raise 'Password is required' unless @_pass
      raise 'Passwords are not the same' unless @_pass == @_pass_confirm

      User.current.update pass:@_pass

      'Password set'
    end
  end

end