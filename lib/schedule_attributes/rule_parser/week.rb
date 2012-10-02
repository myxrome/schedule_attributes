module ScheduleAttributes::RuleParser
  class Week < Day
    def parse
      @rule = IceCube::Rule.weekly(interval)
      @rule = @rule.day(*weekdays) if !weekdays.empty?

      super
    end

    private

    def weekdays
      IceCube::TimeUtil::DAYS.keys.select{ |day| @options[day].to_i == 1 }
    end
  end
end
