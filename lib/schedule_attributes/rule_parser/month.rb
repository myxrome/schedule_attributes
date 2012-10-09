module ScheduleAttributes::RuleParser
  # Parse an options hash to a monthly rule
  #
  # Assume a monthly rule starting on the :start_date if no :ordinal_day or
  # :ordinal_week is given. If both of these options are present in the options
  # hash, one can be selected with :ordinal_unit = ("day" or "week").
  #
  # Weekdays are applied for :ordinal_week only
  #
  class Month < Base

    # @return [IceCube::Rule]
    #
    def parse_options
      @rule = IceCube::Rule.monthly(interval)
      @rule.until(end_date) if end_date

      case ordinal_unit
      when :day
        @rule.day_of_month(ordinal_day)
      when :week
        # schedule.add_recurrence_rule Rule.monthly.day_of_week(:tuesday => [1, -1])
        # every month on the first and last tuesdays of the month
        @rule.day_of_week(weekdays_by_week_of_month)
      else
        @rule
      end
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
