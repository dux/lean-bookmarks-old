class User < MasterModel

  def self.current
    Thread.current[:lux][:user]    
  end

  def self.current=(u)
    Thread.current[:lux][:user] = u
  end

  def self.request
    Thread.current[:lux][:sinatra].request
  end

  def avatar(size=200)
    return self[:avatar] if self[:avatar]# .or('avatar.jpeg')
    robo = CGI.escape(%[http://static1.robohash.org/#{self.id}.png?set=set#{self.id%3+1}&size=#{size}x#{size}])
    %[http://www.gravatar.com/avatar/#{Digest::MD5.new.update(self.email.downcase)}?s=#{size}&d=#{robo}]
  end

  def pass=(str)
    return str if str == '' || str.length == 40
    self[:pass] = Crypt.sha1(str)
  end

  def self.login(e, p)
    User.where( email:e, pass:Crypt.sha1(p) ).first || nil
  end

  def self.quick_create(email)
    email = email.downcase
    Validate.email(email)

    u = User.where( email:email ).first
    return u if u
    u = User.create :email=>email, :name=>email.split('@')[0].capitalize.gsub(/\./,' ')
  end

  def can?(what=:read)
    return true if what == :read
    return true if id == User.current.try(:id)
    false
  end

  def is_admin
    true
  end

  def set_token
    update_column :token, Crypt.sha1(DateTime.now.to_s)
  end

  def token
    return self[:token] if self[:token].present?
    set_token
  end

end
