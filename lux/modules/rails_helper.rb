module RailsHelper
  
  def path_to_image(src)
    return src if src[0, 4] == 'http'
    src = "/images/#{src}" unless src[0, 1] == '/'
    src
  end

  def image_tag(source, options={})
    options = options.symbolize_keys

    src = options[:src] = path_to_image(source)

    unless src =~ /^(?:cid|data):/ || src.blank?
      options[:alt] = options.fetch(:alt){ src.sub(/\.\w+$/,'').humanize }
    end

    options.tag("img")
  end

  def link_to(name, where=nil, opts={})
    where ||= name
    opts[:href] = where
    opts[:target] ||= 'new_window' if where =~ /https?:\/\//
    opts.tag :a, name
  end

end