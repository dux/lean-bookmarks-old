class PromoCell < LuxCell

  layout :main

  template :index, :login, :css

  def set_password
    if hash = Lux.params[:user_hash]
      usr_email = Crypt.decrypt(hash)
      usr = User.quick_create(usr_email)
      Lux.request.session[:u_id] = usr.id
      Lux.redirect Lux.request.path
    end
  end

end