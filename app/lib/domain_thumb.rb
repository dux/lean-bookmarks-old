# Cache-Control:max-age=315360000, public
# Connection:keep-alive
# Expires:max

class DomainThumb
  attr_accessor :full_local
  attr_accessor :local

  def self.render(crypted_domain)
    # basic headers
    Page.sinatra.response.headers['Connection'] = 'keep-alive'

    dt = DomainThumb.new crypted_domain.split('.').first

    return Page.status(304) if Page.sinatra.request.env['HTTP_IF_NONE_MATCH'] == "W/#{crypted_domain}"

    if dt.exists?
      if dt.is_placeholder?
        if dt.is_fresh?
          dt.deliver_placeholder # it is freshly downloaded, deliver placeholder
        else
          dt.download_and_deliver
        end
      else
        # real file, nota placeholder
        dt.deliver_screenshot
      end
    else
      dt.download_and_deliver
    end
  end

  def initialize(crypted_domain)
    @crypted_domain = crypted_domain
    @domain = Crypt.decrypt crypted_domain

    hash = Digest::MD5.hexdigest("tajna-#{@domain}")
    local_dir = "/thumbs/#{hash[0,1]}"
    full_local_dir = "#{Dir.pwd}/public#{local_dir}"

    Dir.mkdir(full_local_dir) unless Dir.exists?(full_local_dir)

    @local = "#{local_dir}/#{hash}.png"
    @full_local = "#{full_local_dir}/#{hash}.png"
  end

  def deliver_placeholder
    Page.sinatra.content_type('image/gif')
    Page.sinatra.response.headers['Cache-Control'] = 'max-age=300, public'
    Page.body = File.read('./public/loading.gif')
  end

  def deliver_screenshot
    Page.sinatra.content_type('image/png')
    Page.sinatra.response.headers['Cache-Control'] = 'max-age=315360000, public'
    Page.sinatra.response.headers['Expires'] = 'max'
    Page.sinatra.response.headers['ETag'] = "W/#{@crypted_domain}"
    Page.body = File.read(@full_local)
  end

  def download_and_deliver
    download

    if is_placeholder?
      deliver_placeholder # fck it, still no fresh thumbnail
    else
      deliver_screenshot # yay, we have screenshot
    end
  end

  def download
    `curl 'http://free.pagepeeker.com/v2/thumbs.php?size=l&url=#{@domain}' -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6,fr;q=0.4,hr;q=0.2,bs;q=0.2,sr;q=0.2,it;q=0.2,sv;q=0.2,es;q=0.2' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/#{(400..550).to_a.sample.to_s}.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Cookie: PagePeeker=PagePeeker_NS41' -H 'Connection: keep-alive' --compressed > #{@full_local}`
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

end