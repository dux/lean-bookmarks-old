class Bucket < MasterModel
  include PgarrayPlugin::Model

  array_on :tags, :bucket_ids

  validates :name, :presence=>{ :message=>'Bucket name is required' }

  has_many :links
  has_many :notes
  has_many :buckets

  default_scope -> { order('updated_at desc').where('active=?', true) }

  def self.can(what=:read)
    my
  end

  def self.unsorted_bucket
    unscoped.order('id asc').my.first || create!(name:'Various')
  end

  def self.can(what=:read)
    where(:created_by=>User.current.id)
  end

  def self.as_select
    ret = []
    for el in Bucket.select('id, name, (select count(*) from links where bucket_id=buckets.id) as cnt').limit(40)
      el.cnt = 999 if el.cnt > 999
      ret.push [el.id, "#{el.name.trim(20)} (#{el.cnt})"]
    end
    ret
  end

  def desc
    Cache.fetch("bucket-info-#{id}") do
      ret = []
      lcount = links.count
      ncount = notes.count
      bcount = self[:child_buckets].length

      h = Template.helper(:main)
      ret.push "#{lcount} #{h.svg_ico(:link, 12)}" if lcount > 0
      ret.push "#{ncount} #{h.svg_ico(:note, 12)}" if ncount > 0
      ret.push "#{bcount} #{h.svg_ico(:bucket, 12)}" if bcount > 0
      ret.join(' ')
    end
  end

  def template
    tpl = self[:template].or('automatic')
    tpl = 'default' if tpl == 'automatic'
    tpl
  end

  def c_buckets
    Bucket.tagged_with(id, 'child_buckets')
  end

end