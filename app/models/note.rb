class Note < MasterModel
  validates :name, presence:{ message:'Name is required' }

  # def self.can(what=:read)
  # def can?(what=:read)

  belongs_to :bucket

  default_scope -> { order('notes.updated_at desc').where('notes.active=?', true) }

  validate do
    self[:bucket_id] ||= Bucket.my.first.id
  end
  
  def self.can(what=:read)
    my
  end

end