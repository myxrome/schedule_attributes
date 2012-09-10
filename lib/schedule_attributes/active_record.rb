require 'schedule_attributes/core'

module ScheduleAttributes::ActiveRecord
  extend ActiveSupport::Concern
  include ScheduleAttributes::Core

  module ClassMethods
    attr_accessor :schedule_attributes_key
  end

  module Sugar
    def has_schedule_attributes(options={:column_name => :schedule_yaml})
      key = options[:column_name] || ScheduleAttributes::DEFAULT_ATTRIBUTE_KEY
      @schedule_attributes_key = key
      include ScheduleAttributes::ActiveRecord
    end
  end

  included do
    unless @schedule_attributes_key
      key = ScheduleAttributes::DEFAULT_ATTRIBUTE_KEY
      @schedule_attributes_key = key
    end
  end

  protected

  def read_schedule_attributes
    read_attribute(self.class.schedule_attributes_key)
  end

  def write_schedule_attributes(value)
    write_attribute(self.class.schedule_attributes_key, value)
  end
end

# Injects the has_schedule_attributes method when loading without Rails
if defined? ActiveRecord::Base
  ActiveRecord::Base.send :extend, ScheduleAttributes::ActiveRecord::Sugar
end
