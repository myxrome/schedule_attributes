module ScheduleAttributes::RuleParser
  class Base
    # @param [Hash] options
    #
    def initialize(input)
      @input = input
      @rule ||= rule_factory.daily(input.interval)
      @exceptions ||= []
    end

    attr_reader :input

    def rule
      parse_options
      set_end_date
      set_yearly_months

      @rule
    end

    def exceptions
      set_yearly_month_exceptions

      @exceptions
    end

    private

    def rule_factory
      IceCube::Rule
    end

    def set_end_date
      @rule.until(input.end_date) if input.ends?
    end

    def set_yearly_months
      if (input.yearly_start_month? || input.yearly_end_month?) && (yearly_months.length < 12)
        @rule.month_of_year(*yearly_months)
      end
    end

    def set_yearly_month_exceptions
      if input.yearly_start_month_day?
        @exceptions << rule_factory.daily
                      .month_of_year(start_month)
                      .day_of_month(*1...start_day)
      end

      if input.yearly_end_month_day?
        @exceptions << rule_factory.daily
                       .month_of_year(end_month)
                       .day_of_month(*(end_day+1)..31)
      end
    end

    def yearly_months
      y1 = Date.current.year
      y2 = start_month > end_month ? y1+1 : y1
      range = Date.new(y1,start_month,1)..Date.new(y2,end_month,1)
      range.group_by(&:month).keys
    end

    def start_month
      param_to_month(input.yearly_start_month, 1)
    end

    def end_month
      param_to_month(input.yearly_end_month, 12)
    end

    def start_day
      param_to_day(input.yearly_start_month_day, 1)
    end

    def end_day
      param_to_day(input.yearly_end_month_day, 31)
    end

    def param_to_month(param, default)
      (param.to_i % 12).tap { |m| return default if m == 0 }
    end

    def param_to_day(param, default)
      (param.to_i % 31).tap { |d| return default if d == 0 }
    end
  end
end
