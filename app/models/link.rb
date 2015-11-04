class Link < MasterModel
  include PgarrayPlugin::Model

  validates :name, :presence=>{ :message=>'Link name is required' }

  belongs_to_cached :bucket
  # belongs_to :bucket

  array_on :tags

  default_scope -> { order('links.updated_at desc').where(active:true) }

  scope :is_article, -> { where('is_article=?', true) }
  scope :not_article, -> { where('coalesce(is_article, false)=?', false) }

  validate do
    errors.add(:url, 'URL is not link') if self[:url].present? && self[:url] !~ /^https?:\/\//
  end

  def self.can(what=:read)
    where(:created_by=>User.current.id)
  end

  def domain
    return self[:domain] if self[:domain].present?
    self[:domain] = self[:url].split('//')[1].split('/')[0].sub(/^www\./,'').downcase.sub(/[^\w_\-\.]/,'')
  end

  def thumbnail
    return url if url =~ /\.jpg/i;
    # url = domain.split('.').count > 2 ? domain : "www.#{domain}"
    if domain == 'youtube.com'
      "http://img.youtube.com/vi/#{Url.new(url).qs(:v)}/0.jpg"
    elsif domain.index('imgur.com') && url =~/\.(jpg|gif)/
      u = url.split('.')
      u[2] += 'm'
      u.join('.')
    else
      %[http://free.pagepeeker.com/v2/thumbs.php?size=l&url=#{domain}]
      "/t/#{Crypt.encrypt(domain)}.png"
    end
    # %[http://web-services.s3.amazonaws.com/web-shot/#{domain}.png]
    # %[http://www.bitpixels.com/getthumbnail?code=93691&size=200&url=#{domain}]
    # %[http://www.robothumb.com/src/?size=240x180&url=http://#{domain}]
    # %[http://localhost:8080/fit?page=http://#{url}&size=300x225]
  end

  def ico
    "https://www.google.com/s2/favicons?domain=#{domain}"
  end

  def url=(data)
    self[:url] = data
    self[:domain] = domain
    raise 'Bad URL' if self[:domain].empty?
    self[:is_article] = article?
    data
  end

  def fetch_name
    begin
      data = RestClient.get self[:url]
      doc = Nokogiri::HTML(data)

      self[:name] = doc.xpath("//title").first.text.gsub(/^\s+|\s+$/,'')
      self[:description] = doc.xpath("//meta[@name='description']").first[:content]
    rescue
      self[:name] = domain
    end
    self[:name]
  end

  def article?
    path = url.split('/')
    path.shift(3)
    path = path.join('')
    data = path =~ /[\-\d\?=]/ ? true : false
    update :is_article=>data unless data == is_article
    data
  end

  def figure_out_kind
    kind = ''
    kind = 'vid' if url.index('youtube.com/watch') || url.index('vimeo.com/')
    kind = 'img' if url =~ /\.(jpg|jpeg|gif|png)$/i
    kind = 'doc' if url.index('hackpad.com/') || url.index('https://docs.google.com') || url.index('https://office.live.com/')
    update(:kind=>kind) if kind != self[:kind]
  end

  def data
    ret = att_prepare '*', :url, :domain, :ico, :tags, :description, :bucket, :thumbnail
    ret[:ago] = Time.ago(created_at)
    ret
  end

end