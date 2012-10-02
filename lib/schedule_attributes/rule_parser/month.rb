module ScheduleAttributes::RuleParser
  class Month < Day
    def parse
      @rule = IceCube::Rule.monthly(interval)
      @rule = case ordinal_unit
              when :day
                @rule.day_of_month(ordinal_day)
              when :week
                # schedule.add_recurrence_rule Rule.monthly.day_of_week(:tuesday => [1, -1])
                # every month on the first and last tuesdays of the month
                @rule.day_of_week(weekdays_by_week_of_month)
              else
                @rule
              end

      super
    end

    private

    def ordinal_unit
      @options[:ordinal_unit] ? @options[:ordinal_unit].to_sym : nil
    end

    def ordinal_week
      @options[:ordinal_week].to_i
    end

    def ordinal_day
      [@options[:ordinal_day].to_i, 1].max
    end

    def weekdays_by_week_of_month
      selected_weekdays.collect(Hash.new) do |memo, wd|
        memo[wd] = ordinal_week
      end
    end
  end
end
