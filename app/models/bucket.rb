class Bucket < MasterModel

  validates :name, :presence=>{ :message=>'Bucket name is required' }

  default_scope -> { order('updated_at desc').where('active=?', true) }

  def self.unsorted_bucket
    unscoped.order('id asc').my.first || create!(name:'UNsorted')
  end
 
end