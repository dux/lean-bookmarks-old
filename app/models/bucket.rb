class Bucket < MasterModel
  include PgarrayPlugin::Model

  validates :name, :presence=>{ :message=>'Bucket name is required' }

  array_on :tags

  default_scope -> { order('updated_at desc').where('active=?', true) }

  has_many :links
  has_many :notes
  has_many :buckets

  def self.unsorted_bucket
    unscoped.order('id asc').my.first || create!(name:'General')
  end

  def desc
    ret = []
    lcount = links.count
    ncount = notes.count
    bcount = buckets.count

    h = Template.helper(:main)
    ret.push "#{lcount} #{h.svg_ico(:link, 12)}" if lcount > 0
    ret.push "#{ncount} #{h.svg_ico(:note, 12)}" if ncount > 0
    ret.push "#{ncount} #{h.svg_ico(:bucket, 12)}" if bcount > 0
    # ret.push lcount.pluralize('link') if lcount > 0
    # ret.push ncount.pluralize('note') if ncount > 0
    # ret.to_sentence
    ret.join(' ')
  end

  def template
    tpl = self[:template].or('automatic')
    tpl = 'default' if tpl == 'automatic'
    tpl
  end

end