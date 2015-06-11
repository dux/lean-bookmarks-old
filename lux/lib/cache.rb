# config/enviroment.rb
# config.cache_store = :dalli_store, nil, { :namespace=>':cp', :expires_in=>1.day, :compress=>true }
# config.cache_store = :mem_cache_store

# def view(name, *keys, &block)
#   ret = ['v']
#   for el in keys
#     if el.respond_to? :updated_at
#       ret.push "#{el.class.name}-#{el.id}-#{el.updated_at.to_i}"
#     elsif el.kind_of? Symbol
#       ret.push el.to_s
#     elsif el.respond_to? :id
#       ret.push "#{el.class.name}:#{el.id}" rescue ''
#     else
#       ret.push ret.to_s rescue 'nil'
#     end
#   end
#   ret.push block.to_s
#   ret.push User.request.path
#   key = "#{name}-"+Crypt.md5(ret.join('-'))

#   data = App.no_cache ? nil : Cache.read(key)
#   return concat(data) if data
#   data = capture { block.call(true) } || ' '
#   Cache.write(key, data)
#   concat(data)
# end


class Cache
  @ns = 'app:'

  def self.exec
    # Thread.current[:_memcached]
    # @conn ||= ActiveSupport::Cache::MemCacheStore.new("localhost")
    # @conn
    Rails.cache
  end

  def self.get(key)
    exec.read "#{@ns}#{key}"
  end

  def self.read(key)
    exec.read "#{@ns}#{key}"
  end

  def self.set(key, data=nil)
    exec.write "#{@ns}#{key}", data
  end

  def self.write(key, data=nil)
    exec.write "#{@ns}#{key}", data
  end

  def self.delete(key, data=nil)
    exec.delete "#{@ns}#{key}"
  end

  def self.fetch(key)
    cache_key = "#{@ns}#{key}"
    exec.delete cache_key if App.no_cache
    exec.fetch cache_key do
      yield
    end
  end
end
