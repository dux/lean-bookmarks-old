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
  @@client = Dalli::Client.new('localhost:11211', { :namespace=>Digest::MD5.hexdigest(__FILE__)[0,4], :compress => true,  :expires_in => 1.hour })

  class << self

    def exec
      @@client
    end

    def get(key)
      exec.get(key)
    end

    def read(key)
      exec.get(key)
    end

    def set(key, data, ttl=nil)
      exec.set(key, data, ttl)
    end

    def write(key, data, ttl=nil)
      exec.set(key, data, ttl)
    end

    def delete(key, data=nil)
      exec.delete(key)
    end

    def fetch(key, ttl=nil)
      exec.delete key if Lux.no_cache
      exec.fetch key, ttl do
        yield
      end
    end

  end
end
