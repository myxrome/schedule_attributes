module ScheduleAttributes::RuleParser
  class Year < Day
    def parse
      @rule = rule_factory.yearly(interval)
                          .month_of_year(start_date.month)
                          .day_of_month(start_date.day)
      super
    rescue ArgumentError
    end
  end
end
