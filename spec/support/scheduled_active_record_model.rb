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

class ScheduledActiveRecordModel < ActiveRecord::Base
  has_schedule_attributes :column_name => :my_schedule

  def initialize(*args)
    super
    initializer_override_doesnt_break = true
  end
end
