class Domain < MasterModel
  validates :name, presence:{ message:'Name is required' }

  default_scope -> { order('domains.updated_at desc') }

  def name=(data)
    self[:name] = data.to_s.downcase.sub(/[^\w_\-\.]/,'')
  end

  def self.get(name)
    name = name.to_s.downcase.sub(/[^\w_\-\.]/,'')
    search_or_new( created_by:User.current.id, name:name )
  end

  def ico
    "https://www.google.com/s2/favicons?domain=#{name}"
  end

  def path(where=nil)
    "/domain/#{name}"
  end

end