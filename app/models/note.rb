class Note < MasterModel
  validates :name, presence:{ message:'Name is required' }

  # def self.can(what=:read)
  # def can?(what=:read)

  belongs_to :bucket

  default_scope -> { order('updated_at desc') }
  
  def self.can(what=:read)
    my
  end

end