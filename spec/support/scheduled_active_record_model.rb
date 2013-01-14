require 'active_record'
require 'schedule_attributes/active_record'

class ActiveRecord::Base
  extend ScheduleAttributes::ActiveRecord::Sugar

  establish_connection(
    adapter: "sqlite3",
    database: ":memory:"
  )
end

ActiveRecord::Migration.create_table :calendars do |t|
  t.text :schedule
  t.text :my_schedule
end

class CustomScheduledActiveRecordModel < ActiveRecord::Base
  self.table_name = :calendars
  has_schedule_attributes :column_name => :my_schedule

  def default_schedule
    s = IceCube::Schedule.new(Date.today.to_time)
    s.add_recurrence_rule IceCube::Rule.hourly
    s
  end

  def initialize(*args)
    super
    @can_access_default_schedule_in_initialize = my_schedule.next_occurrence
  end
end

class DefaultScheduledActiveRecordModel < ActiveRecord::Base
  self.table_name = :calendars
  has_schedule_attributes

  def initialize(*args)
    super
    @can_access_default_schedule_in_initialize = schedule.next_occurrence
  end
end
