class Bucket < MasterModel

  validates :name, :presence=>{ :message=>'Bucket name is required' }

  
end