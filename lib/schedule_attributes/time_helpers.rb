module ScheduleAttributes
  module TimeHelpers
    def self.parse_in_zone(str)
      return str if str.is_a?(Time)

      if Time.respond_to?(:zone) && Time.zone
        str.is_a?(Date) ? str.to_time_in_current_zone : Time.zone.parse(str)
      else
        Time.parse(str)
      end
    end
  end
end
