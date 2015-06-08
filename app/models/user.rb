class User < ActiveRecord::Base

  def self.current
    Thread.current[:lux][:user]    
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

end
