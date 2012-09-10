module ScheduleAttributes
  module TimeHelpers
    def self.parse_in_timezone(str)
      if Time.respond_to?(:zone) && Time.zone
        Time.zone.parse(str)
      else
        Time.parse(str)
      end
    end
  end
end
