# class FooBar < GenericModel
# 
#   values :linkedin => { :id=>1, :name=>'LinkedIn', :desc=>'lalal' },
#          :facebook => { :id=>2, :name=>'Facebook' },
#          :twitter  => { :id=>3, :name=>'Twitter' },
#          :google   => { :id=>4, :name=>'Google' },
#          :email    => { :id=>5, :name=>'Email'} , 
#          :mobile   => { :id=>6, :name=>'Mobile' }
# 
#   values [1, 'LinkedIn'],
#          [2, 'Facebook'],
#          [3, 'Twitter'],
#          [4, 'Google'],
#          [5, 'Email'],
#          [6, 'Mobile']
#
#   def ico
#     %{<img src="/images/type/#{code}.png" style="width:16px; height:16px; vertical-align:middle; " />}
#   end
# 
# end

class GenericModel < Struct.new(:id, :name, :code, :generic)

  @@keys_in_use = {}

  def self.values(*values)
    if values[0].is_a?(Array)
      ret = {}
      for el in values
        val = { :id=>el[0], :name=>el[1] }
        val.merge!(el[2]) if el[2]
        ret[el[1].downcase.to_sym] = val
      end
      @values = ret
    else
      @values = values[0]
    end
  end

  def self.tokenize(el)
    o = new
    o.code = el.shift
    el = el.first
    o.id = el.delete(:id)
    o.name = el.delete(:name) || o.code.to_s.humanize
    o.generic = {}
    for key, val in el
      o.generic[key] = val
      @@keys_in_use[key] = true
    end
    o
  end

  def self.find(*args)
    val = args.first
    for el in all
      return el if (val.is_a?(Symbol) && el.code == val) || (el.id == (val.to_i rescue false))
    end
    return nil
  end

  def self.all(*args)
    @all ||= @values.map { |e| tokenize(e) }
    if args && args[0].is_a?(Symbol)
      return @all.select { |el| el.generic[:type] == args[0] } 
    end
    @all.sort { |a,b| a[:id] <=> b[:id] }
  end

  def self.find_by_code(val)
    find val.to_sym
  end

  def self.is_generic_model?
    true
  end

  # FIXME for some reason this doesn't work for case..when expressions
  def ==(object)  
    if object.is_a?(Fixnum)
      object == self.id
    elsif object.is_a?(Symbol)
      object == self.code
    elsif object.is_a?(self.class)
      object.id == self.id
    end
  end

  # TODO alias method??
  def to_s
    name
  end  
  
  def to_i
    id
  end
  
  def to_sym
    code
  end
  
  def to_param
    id  
  end

  def method_missing(method_name, *args)
    return self[:generic][method_name] if @@keys_in_use[method_name]
    super(method_name, args)
  end

  def <=>(b)
    self.id <=> b.id
  end

  def destroyed?
    false
  end

  def new_record?
    false
  end

end