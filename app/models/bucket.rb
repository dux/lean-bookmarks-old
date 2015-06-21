class Bucket < MasterModel

  validates :name, :presence=>{ :message=>'Bucket name is required' }

  def self.unsorted_bucket
    unscoped.order('id asc').my.first || create!(name:'UNsorted')
  end
 
end