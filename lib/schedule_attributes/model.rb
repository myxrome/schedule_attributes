require 'schedule_attributes/core'

module ScheduleAttributes::Model
  extend ActiveSupport::Concern
  include ScheduleAttributes::Core

  module ClassMethods
    attr_accessor :schedule_field
  end

  included do
    @schedule_field ||= ScheduleAttributes::DEFAULT_ATTRIBUTE_KEY
  end

  private

  def read_schedule_field
    send(self.class.schedule_field)
  end

  def write_schedule_field(value)
    send("#{self.class.schedule_field}=", value)
  end
end
