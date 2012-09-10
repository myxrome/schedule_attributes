require 'schedule_attributes/core'

module ScheduleAttributes::Model
  extend ActiveSupport::Concern
  include ScheduleAttributes::Core

  module ClassMethods
    attr_accessor :schedule_attributes_key
  end

  included do
    unless @schedule_attributes_key
      column_name = ScheduleAttributes::DEFAULT_ATTRIBUTE_KEY
      @schedule_attributes_key = column_name
    end
  end

  protected

  def read_schedule_attributes
    send(self.class.schedule_attributes_key)
  end

  def write_schedule_attributes(value)
    send("#{self.class.schedule_attributes_key}=", value)
  end
end
