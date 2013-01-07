require 'active_record'
require 'schedule_attributes/active_record'

class ActiveRecord::Base
  extend ScheduleAttributes::ActiveRecord::Sugar
end

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Migration.create_table :scheduled_active_record_models do |t|
  t.text :my_schedule
end

ActiveRecord::Migration.create_table :default_scheduled_active_record_models do |t|
  t.text :schedule
end

class ScheduledActiveRecordModel < ActiveRecord::Base
  has_schedule_attributes :column_name => :my_schedule

  def self.default_schedule
    s = IceCube::Schedule.new(Date.today.to_time)
    s.add_recurrence_rule IceCube::Rule.hourly
    s
  end

  def initialize(*args)
    super
    @can_access_default_schedule = my_schedule.next_occurrence
  end
end

class DefaultScheduledActiveRecordModel < ActiveRecord::Base
  has_schedule_attributes

  def initialize(*args)
    super
    @can_access_default_schedule = schedule.next_occurrence
  end
end
