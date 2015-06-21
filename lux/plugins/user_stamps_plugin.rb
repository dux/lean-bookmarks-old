require 'active_support/concern'

module UserStampsPlugin
  module Model
    extend ActiveSupport::Concern

    included do
      before_save :_set_user_stamps
      belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
      belongs_to :updater, :class_name => "User", :foreign_key => "updated_by"
    end

    def _set_user_stamps
      self[:created_at] = Time.now if ! self[:id] && respond_to?(:created_at)
      self[:updated_at] = Time.now if respond_to?(:updated_at)
      self[:ip] = User.request.ip if respond_to?(:ip)

      return unless respond_to?(:created_by) || respond_to?(:updated_by)
      return errors.add(:base, 'You have to be registered to save data') unless User.current

      self[:created_by] ||= User.current.id if respond_to?(:created_by) && ! self[:id]
      self[:updated_by] = User.current.id if respond_to?(:updated_by)
    end
  end
end
