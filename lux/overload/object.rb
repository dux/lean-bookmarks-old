class Object

  def r(what=nil)
    raise what.kind_of?(String) ? "String -> #{what}" : "#{what.class.name} -> #{what.to_json}"
  end
  
  def l(what=nil)
    puts (what.kind_of?(String) ? what : what.to_json).red
  end
  
  def instance_variables_hash
    Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
  end

  def or(_or)
    self.blank? || self == 0 ? _or : self
  end

  def empty?
    # active record object
    return self.id? if respond_to?(:attributes) && respond_to?(:id) 
    return true if nil?
    return false if self.class.name == 'Class'

    # if ['Arel::Nodes::Equality', 'Arel::SelectManager'].index(self.class.name)
    return false if self.class.name.index('Arel::')
    return length == 0 if kind_of?(Array)
    return keys.length == 0 if kind_of?(Hash)
    return to_s.length == 0 if kind_of?(Time)

    raise "Unknown type #{self.class.name} for empty? given"
  end

end
