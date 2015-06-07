class UserApi < LuxApi

  action :show do
    name 'Show single user based on email'
    params :email, :email
    lambda do
      @error = {}
      @message = 'all good for now'
      User.where(email:params[:email]).first.attributes
    end
  end

  inline_action :index do
    User.order('users.id asc').select('id, email, name')#.limit(3).offset(3)
  end

  def login
    'ok'
  end

end