class MasterModel < ActiveRecord::Base
  self.abstract_class = true

  include EssentialsPlugin::Model
  include SecurityPlugin::Model
  include UserStampsPlugin::Model
  # include LocalizationPlugin::Model
  include CacheingPlugin::Model
  # include PgarrayPlugin::Model

  after_update do
    if self[:bucket_id]
      Bucket.find(self[:bucket_id]).touch rescue false
    end
  end

  def att_prepare(*atts)
    if atts.first == '*'
      atts.shift
      atts.unshift :id, :name, :as_link, :path, :creator, :created_at
    end

    ret = {}
    for el in atts
      data = send(el)
      ret[el] = data.respond_to?(:update) ? data.as_link : data
    end
    ret
  end

end