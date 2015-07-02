class Domain < MasterModel
  validates :name, presence:{ message:'Name is required' }

  default_scope -> { order('domains.updated_at desc') }

  def name=(data)
    self[:name] = data.to_s.downcase.sub(/[^\w_\-\.]/,'')
  end
end