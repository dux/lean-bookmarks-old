class App

  def self.name
    'Demo app'
  end

  def self.base_url
   Lux.sinatra.request.protocol + Lux.sinatra.request.host_with_port
  end

  def self.once(name, &block)
    User.request[:_once_hash] ||= {}
    unless User.request[:_once_hash][name]
      User.request[:_once_hash][name] = true
      yield
    end
  end

  def self.init_for_users
    return Lux.status :forbiden, 'Only for registred users' unless User.current

    false
  end

end