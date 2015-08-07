class {{@object.classify}} < MasterModel
  # include PgarrayPlugin::Model

  # validates :name, :presence=>{ :message=>'Link name is required' }

  # default_scope -> { order('') }

  # def self.can(what=:read)
  #   where(:created_by=>User.current.id)
  # end

  # def self.can?(what=:read)
  #   return true if User.current && User.current.id == created_by
  # end

end