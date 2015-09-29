# u = Url.new('https://www.YouTube.com/watch?t=1260&v=cOFSX6nezEY')
# u.delete :t
# u.hash '160s'
# u.to_s -> 'https://com.youtube.www/watch?v=cOFSX6nezEY#160s'

class Url

  attr_accessor :proto, :host, :port

  def initialize(url)
    if url =~ /:/
      @elms = url.split('/', 4)
    else
      @elms = [url]
      @elms.unshift('','')
    end

    domain_and_port = @elms[2].split(':')
    @domain_parts = domain_and_port[0].to_s.split('.').reverse.map(&:downcase)

    @qs = {}
    path_with_qs = @elms[3].split(/\?|#/)
    path_with_qs[1].split('&').map do |el|
      parts = el.split('=')
      @qs[parts[0]] = url_unescape parts[1]
    end if path_with_qs[1]

    @path = path_with_qs[0] || '/'
    @proto = @elms[0].split(':').first.downcase
    @host = @domain_parts.reverse.join('.')
    @port = domain_and_port[1] ? domain_and_port[1].to_i : 80
  end

  def self.current
    new(Page.sinatra.request.url)
  end

  def self.force_locale(href, loc)
    u = new(href)
    u.locale(loc)
    u.relative
  end

  def url_escape(str)
    str.gsub(/([^ a-zA-Z0-9_.-]+)/n) { '%' + $1.unpack('H2' * $1.size).join('%').upcase }.tr(' ', '+')
  end

  def url_unescape(str)
    str.to_s.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n) { [$1.delete('%')].pack('H*') }
  end

  def domain(what=nil)
    if what
      @host = what
      return self
    end

    @domain_parts.slice(0,2).reverse.join('.')
  end

  def subdomain
    @domain_parts.drop(2).reverse.join('.').or(nil)
  end

  def host_with_port
    %[#{proto}://#{host}#{port == 80 ? '' : ":#{port}"}]
  end

  def query
    @query 
  end

  def path(val=nil)
    return '/'+@path+(@namespace ? ":#{@namespace}" : '') unless val

    @path = val.sub(/^\//,'')
    self
  end

  def delete(*keys)
    keys.map{ |key| @qs.delete(key.to_s) }
    self
  end

  def hash(val)
    @hash = "##{val}"
  end

  def qs(name=nil, value=nil)
    if value 
      @qs[name.to_s] = value
    elsif name
      return @qs[name.to_s]
    else
      @qs
    end
    self
  end

  def namespace(data)
    @namespace = data.to_s
    self
  end

  def locale(what)
    elms = @path.split('/')
    if elms[0] && I18n.available_locales.index(elms[0].to_sym)
      elms[0] = what
    else
      elms.unshift what
    end
    @path = elms.join('/')
    self
  end

  def qs_val
    ret = []
    if @qs.keys.length > 0
      ret.push '?' + @qs.keys.sort.map{ |key| "#{key}=#{url_escape(@qs[key].to_s)}" }.join('&')
    end
    ret.join('')
  end

  def url
    [host_with_port,path, qs_val, @hash].join('')
  end

  def relative
    [path, qs_val, @hash].join('').sub('//','/')
  end

  def to_s
    domain.length > 0 ? url : local_url
  end

end