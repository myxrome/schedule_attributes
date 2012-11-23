require 'schedule_attributes/core'

module ScheduleAttributes::ActiveRecord
  extend ActiveSupport::Concern
  include ScheduleAttributes::Core

  module ClassMethods
    attr_accessor :schedule_field
  end

  module Sugar
    def has_schedule_attributes(options={:column_name => :schedule})
      key = options[:column_name] || ScheduleAttributes::DEFAULT_ATTRIBUTE_KEY
      @schedule_field = key
      serialize key, YAML
      include ScheduleAttributes::ActiveRecord
    end
  end

  included do
    @schedule_field ||= ScheduleAttributes::DEFAULT_ATTRIBUTE_KEY
  end

  private

  def read_schedule_field
    self[self.class.schedule_field]
  end

  def write_schedule_field(value)
    self[self.class.schedule_field] = value
  end
end

# Injects the has_schedule_attributes method when loading without Rails
if defined? ActiveRecord::Base
  ActiveRecord::Base.send :extend, ScheduleAttributes::ActiveRecord::Sugar
end
