class DomainThumb
  attr_accessor :full_local
  attr_accessor :local

  def self.render(domain)
    Page.sinatra.content_type('image/png')

    domain = Crypt.decrypt(domain)

    dt = DomainThumb.new domain

    if dt.exists?
      if dt.is_placeholder?
        if dt.is_fresh?
          Page.body = dt.placeholder_data
        else
          Page.body = deliver_image_data(dt)
        end
      else
        Page.sinatra.response.headers['cache-Control'] = 'public'
        Page.sinatra.response.headers['max-age'] = (60*60*24*365).to_s
        Page.body = dt.image_data
      end
    else
      Page.body = deliver_image_data(dt)
    end
  end

  def self.deliver_image_data(dt)
    dt.download
    if dt.is_placeholder?
      dt.placeholder_data
    else
      Page.sinatra.response.headers['cache-Control'] = 'public'
      Page.sinatra.response.headers['max-age'] = 12*31*24*60*60
      dt.image_data
    end
  end

  def initialize(domain)
    hash = Digest::MD5.hexdigest("tajna-#{domain}")
    local_dir = "/thumbs/#{hash[0,1]}"
    full_local_dir = "#{Dir.pwd}/public#{local_dir}"
    @domain = domain

    Dir.mkdir(full_local_dir) unless Dir.exists?(full_local_dir)
    @local = "#{local_dir}/#{hash}.png"
    @full_local = "#{full_local_dir}/#{hash}.png"
  end

  def download
    `curl 'http://free.pagepeeker.com/v2/thumbs.php?size=l&url=#{@domain}' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6,fr;q=0.4,hr;q=0.2,bs;q=0.2,sr;q=0.2,it;q=0.2,sv;q=0.2,es;q=0.2' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/#{(400..550).to_a.sample.to_s}.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Cookie: PagePeeker=PagePeeker_NS41' -H 'Connection: keep-alive' --compressed > #{@full_local}`
    resolve_path
  end

  def exists?
    File.exists?(@full_local)
  end

  def is_placeholder?
    File.size(@full_local).to_i == 16216
  end

  def is_fresh?
    return (Time.now.to_i - File.mtime(@full_local).to_i) < 300
  end

  def resolve_path
    if is_placeholder?
      [302, placeholder_data]
    else
      [301, image_data]
    end
  end

  def image_data
    File.read(@full_local)
  end

  def placeholder_data
    File.read('./public/thumbs/loading.gif')
  end
end