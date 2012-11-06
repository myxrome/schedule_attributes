module ScheduleAttributes::RuleParser
  class Year < Base

    # @return [IceCube::Rule]
    #
    def parse_options
      @rule = rule_factory.yearly(input.interval).tap do |rule|
        if input.start_date
          rule.month_of_year(input.start_date.month)
              .day_of_month(input.start_date.day)
        end
      end
    end

    private

    def set_yearly_months; nil end

    def set_yearly_month_exceptions; nil end
  end
end
