class UserApi < LuxApi

  def test
    'Ono radi super'
  end

  def show
    User.find(params[:id].to_i).attributes
  end

  def list
    User.select('id, email, name').all
  end

end