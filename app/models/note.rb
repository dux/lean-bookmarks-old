class Note < MasterModel
  include PgarrayPlugin::Model

  array_on :tags

  validates :name, presence:{ message:'Name is required' }

  belongs_to_cached :bucket

  default_scope -> { order('notes.updated_at desc').where('notes.active=?', true) }

  validate do
    self[:bucket_id] ||= Bucket.my.first.id
  end
  
  def self.can(what=:read)
    where(:created_by=>User.current.id)
  end

end