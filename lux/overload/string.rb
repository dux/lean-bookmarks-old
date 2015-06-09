class String
  def to_uri
    CGI.escape(self)
  end

  def label(what=:default)
    allowed = [:default, :success, :warning, :info, :inverse, :danger].map(&:to_s)
    raise "STRING.label [:#{what}] :value can be only #{allowed.join(', ')}" unless what.to_s.in?(*allowed)  
    %[<span class="label label-#{what}">#{self}</span>]
  end

  def link_if(link=self)
    return self if ! link || link.empty?
    link = 'http://'+link unless link.include?('http://')
    return '<a href="'+link+'">'+self+'</a>'
  end

  def as_link
    return self if self.empty?
    link = 'http://'+self.sub(/http:\/\//,'')
    return '<a target="_new" href="'+link+'">'+link+'</a>'
  end

  def tag(node_name, opts={})
    return self unless node_name
    opts.tag(node_name)
  end

  def url_escape
    self.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
    '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end

  def url_unescape
    self.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n) do
    [$1.delete('%')].pack('H*')
    end
  end

  def as_html
    ret = self
    ret = ret.gsub(/([\w\.])\n(\w)/,"\\1<br/>\\2")
    ret
  end

  def html
    self.gsub(/&lt;/, '<').gsub(/&gt;/, '>').gsub(/&amp;/,'&')
  end

  def trim(len)
    return self if self.length<len
    data = self.dup[0,len]+'&hellip;'
    data.html_safe
  end

  def in?(*what)
    for el in what
      return true if self == el.to_s
    end
    false
  end

  def md5
    Crypt.md5(self)
  end

  def sanitize
    Sanitize.clean(self, :elements=>%w[span ul ol li b bold i italic u underline hr br p], :attributes=>{'span'=>['style']} )
  end

  def markdown(more=false)
    ret = Kramdown::Document.new(self).to_html
    if more
      ret.sub!(/<p>https:\/\/gist.github.com\/([\w_\/]+)<\/p>/,'</div><br /><div class="widget gist" data="\\1"></div><div class="box">')
    end
    ret
  end

  def html_safe
    self
  end
end

class NilClass

  def as_html
    ''
  end

  def markdown
    ''
  end

end
