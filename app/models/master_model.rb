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

end