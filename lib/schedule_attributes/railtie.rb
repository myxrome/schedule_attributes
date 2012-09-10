require 'schedule_attributes/active_record'

module ScheduleAttributes
  class Railtie < Rails::Railtie
    initializer "active_record.initialize_schedule_attributes" do
      ActiveSupport.on_load(:active_record) do
        class ActiveRecord::Base
          extend ScheduleAttributes::ActiveRecord::Sugar
        end
      end
    end
  end
end
