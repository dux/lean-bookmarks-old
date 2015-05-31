class Hash
  def h
    Hashie::Mash.new self
  end

	def tag(node=nil, text=nil)
		ret = ''
		self.each { |k,v|
      ret += ' '+k.to_s.gsub(/_/,'-')+'="'+v.to_s.gsub(/"/,'&quot;')+'"' if v.present?# if ['id','title','class','name','data-','onmousedown','onclick','href'].include?k.to_s 
    }
    if node
      text ||= '' if node.to_s == 'button'
      return text ? %{<#{node}#{ret}>#{text}</#{node}>} : %{<#{node}#{ret} />}
    end
    ret
	end

	def strip_empty
		self.delete_if { |k,v| !v || v.to_s.empty? }
	end

  def to_struct(name='ToStructGeneric')
    Struct.new(name, *keys).new(*values)
  end

end

class Struct
  def to_hash
    Hash[*members.zip(values).flatten]
  end
end
