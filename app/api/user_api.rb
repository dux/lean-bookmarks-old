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

  name 'Login via email and pass'
  params :email, :email, :req
  params :pass, :req
  action :login do
    usr = User.login(@_email, @_pass)

    raise 'User not found, bad passord or email' unless usr
    
    usr.attributes
  end

end