class Link < MasterModel
  include PgarrayPlugin::Model

  validates :name, :presence=>{ :message=>'Link name is required' }

  array_on :tags

  default_scope -> { order('links.updated_at desc').where('active=?', true) }

  scope :is_article, -> { where('is_article=?', true) }
  scope :not_article, -> { where('coalesce(is_article, false)=?', false) }

  validate do
    errors.add(:url, 'URL is not link') if self[:url].present? && self[:url] !~ /^https?:\/\//
    for el in [:name, :description]
      self[el] = self[el][0, 255] if self[el]
    end
  end

  def domain
    return self[:domain] if self[:domain].present?
    self[:domain] = self[:url].split('//')[1].split('/')[0].sub(/^www\./,'').downcase.sub(/[^\w_\-\.]/,'')
  end

  def thumbnail
    # url = domain.split('.').count > 2 ? domain : "www.#{domain}"
    if domain == 'youtube.com'
      "http://img.youtube.com/vi/#{Url.new(url).qs(:v)}/0.jpg"
    else
      %[http://free.pagepeeker.com/v2/thumbs.php?size=l&url=#{domain}]
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
    return path =~ /[\-\d\?=]/ ? true : false
  end

end