# = table User.desc, :class=>'table table-striped hover', :tr=>{ href:lambda { |el| el.path(:admin) } } do
#   - row :id, :width=>40, :align=>:r, :name=>'ID'
#   - row :is_admin, data:lambda { |el| el ? 'yes'.label(:success) : '-' }, align:'c', width:40, :name=>'Admin?'
#   - row :name
#   - row :email
#   - row :org_id, :data=>:auto
#   - row :created_at, data:lambda { |el| short el }, width:100, align:'r'
#   - row :created_at, as:short

module TableHelper

  def table(list, opts={})
    begin
      if list.length == 0 && opts[:or]
        return opts[:or].html_safe
      end
    rescue
      return "TABLE helper ERROR, querry error: #{$!.message}" 
    end
    @html_table = HtmlTable.new list, opts
    capture do; yield; end
    data = @html_table.render
    ret = opts.tag :table, data
    ret += %[<br clear="all" />#{paginate list}] if list.respond_to?(:total_pages)
    ret.html_safe
  end

  def row(name, opts={}, &block)
    if name.kind_of?(Symbol)
      opts[:field] = name
    elsif name.kind_of?(Proc)
      opts[:data] = name
    else
      opts = name
    end
    @html_table.add opts
  end

end

class HtmlTable

  def initialize(list, opts={})
    @list     = list
    @table_tr = opts.delete(:tr) || {}
    @cols     = []
  end

  def add(opts={})
    @cols.push opts
  end

  def render
    out = []
    header = []
    for opts in @cols
      opts ||= {}
      if opts[:as]
        send "as_#{opts.delete(:as)}", opts
      end

      opts[:align] = :right if opts[:align].try(:to_sym) == :r
      opts[:align] = :center if opts[:align].try(:to_sym) == :c
      tag = { style:'' }
      tag[:style] += "; text-align:#{opts[:align]}" if opts[:align]
      tag[:style] += "; width: #{opts[:width].kind_of?(String) ? opts[:width] : opts[:width].to_s+'px'}" if opts[:width]
      data = opts[:name] || opts[:field].to_s.humanize
      header.push tag.tag :th, data
    end
    out.push header.join('')

    for data in @list
      @data_row = data
      row = []
      for opts in @cols
        td_value = '' 
        if opts[:data].kind_of?(Proc)
          td_value = opts[:data].call( opts[:field].present? ? data[opts[:field]] : data) 
        elsif opts[:field]
          td_value = data.send(opts[:field])
        end
        tag = { style:'' }
        tag[:style] += "; text-align:#{opts[:align]}" if opts[:align]
        row.push tag.tag :td, td_value
      end

      row_hash = {}
      for k,v in @table_tr
        row_hash[k] = v.kind_of?(Proc) ? v.call(data) : v
      end

      out.push row_hash.tag(:tr, row.join(''))
    end

    out.join("\n")
  end

  def as_boolean(opts)
    opts[:data] ||= Proc.new { |el| el ? 'Yes'.wrap(:span, style:'color:#080') : '-' }
    opts[:width] ||= 60
    opts[:align] ||= :c
  end

  def as_user(opts)
    opts[:data] ||= Proc.new { |el| User.find(el).as_link(:admin) }
    opts[:width] ||= 200
  end

  def as_ago(opts)
    opts[:data] ||= Proc.new { |el| App.ago(el) }
    opts[:width] ||= 140
    opts[:align] ||= :r
  end

  def as_lang(opts)
    name = opts[:field]
    opts[:data] = Proc.new { |el|
      langs = JSON.parse(@data_row[name]).or({}) rescue {}
      langs = HashWithIndifferentAccess.new(langs)
      ret = I18n.available_locales.map{|el| %[<span class="label label-#{langs[el] ? :info : :default}">#{el}</span>] }.join(' ')    
      "#{ret} #{@data_row.send(name)}"
    }
  end

end