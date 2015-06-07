class Object

  def r(what=nil)
    raise what.kind_of?(String) ? what : what.to_json
  end
  
  def instance_variables_hash
    Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
  end

  def or(_or)
    self.blank? ? _or : self
  end

end
