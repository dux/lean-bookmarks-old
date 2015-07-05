class Domain < MasterModel
  validates :name, presence:{ message:'Name is required' }

  default_scope -> { order('domains.updated_at desc') }

  def name=(data)
    self[:name] = data.to_s.downcase.sub(/[^\w_\-\.]/,'')
  end

  # def get(name)
  #   d = Domain.search_or_new( :created_by=>User.current.id, :name=>name)
  #   d.
  # end
end