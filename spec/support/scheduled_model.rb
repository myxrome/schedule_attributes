require 'schedule_attributes'

class ScheduledModel
  include ScheduleAttributes::Model
  attr_accessor :schedule

  schedule_field = :schedule

  def schedule
    @schedule or ScheduleAttributes.default_schedule
  end

  def schedule=(new_schedule)
    @schedule = new_schedule
  end
end
