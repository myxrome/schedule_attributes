module ScheduleAttributes
  module TimeHelpers
    def self.parse_in_zone(str)
      if Time.respond_to?(:zone) && Time.zone
        return str.in_time_zone if str.is_a?(Time)
        str.is_a?(Date) ? str.to_time_in_current_zone : Time.zone.parse(str)
      else
        return str if str.is_a?(Time)
        Time.parse(str)
      end
    end

    def self.today
      if Time.respond_to?(:zone) && Time.zone
        Date.current.to_time_in_current_zone
      else
        Date.today.to_time
      end
    end
  end

  module DateHelpers
    def self.today
      if Time.respond_to?(:zone) && Time.zone
        Date.current.to_time_in_current_zone
      else
        Date.today.to_time
      end
    end
  end
end
