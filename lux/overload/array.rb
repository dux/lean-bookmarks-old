class Array
	def as_ul(opt={})
		ret = []
		for href, name, attrs in self
			attrs ||= {}
			attrs[:active] ||= true if href == opt[:active]

			# takes img or opt image :img=>'/images/ico/?.png'
			img = attrs[:img] ? %{<img src="#{opt[:img] ? opt[:img].sub(/\?/, attrs[:img]) : attrs[:img]}" />} : nil

			nclass = []
			nclass.push('active') if attrs.delete(:active)
			nclass.push('icon') if attrs.delete(:img)
			nclass = nclass.length > 0 ? ' class="'+nclass.join(' ')+'"' : nil

			ret << %{<li#{nclass}>#{img}<a href="#{href}"#{attrs.tag}>#{name}</a></li>}
		end
		ret = ret.join("\n\t")
		return nil if ret.blank?
		ret = %{<ul id="#{opt[:id]}">\n\t#{ret}\n</ul>} if opt[:id]
		ret
	end

  def to_csv
    ret = []
    for row in self
    	add = []
    	for el in row
    		add << '"'+el.to_s.gsub(/\s+/,' ').gsub(/"/,"''")+'"'
	    end
	    ret.push(add.join(';'))
    end
    ret.join("\n")
  end

  def random
    sample    
  end

  def wrap(tag)
    map{ |el| %[<#{tag}>#{el}</#{tag}>] } 
  end
end

# class WillPaginate::Collection 
#  def ids
#    self.map(&:id)
#  end
# end

