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
    User.select('id, email, name')
  end

end