module ScheduleAttributes::RuleParser
  class Base
    # Rules don't actually apply the :start_date option except as a potential
    # default when parsing. The :start_date is used for building the schedule
    # that the rule is attached to. However, rules can still an "until"
    # :end_date inside their containing schedule. Currently we don't expose
    # separate end dates for individual rules.
    #
    # @param [Hash] options
    # @option [String] :interval
    # @option [String] :end_date
    #
    def initialize(options)
      @options = options.with_indifferent_access
      @rule ||= rule_factory.daily(interval)
      @exceptions ||= []
    end

    def rule
      parse_options
      if @options[:end_date].present? && @options[:ends] != "never"
        @rule.until(end_date)
      end
      @rule
    end

    def exceptions
      if (start_month? || end_month?) && (yearly_months.length < 12)
        @rule.month_of_year(*yearly_months)
      end

      if start_day?
        @exceptions << rule_factory.daily
                      .month_of_year(start_month)
                      .day_of_month(*1...start_day)
      end

      if end_day?
        @exceptions << rule_factory.daily
                       .month_of_year(end_month)
                       .day_of_month(*(end_day+1)..31)
      end

      @exceptions
    end

    private

    def rule_factory
      IceCube::Rule
    end

    def start_date
      return Time.now unless @options[:start_date].present?
      TimeHelpers.parse_in_zone(@options[:start_date])
    end

    def end_date
      @options[:end_date].present? ? TimeHelpers.parse_in_zone(@options[:end_date]) : nil
    end

    def interval
      [@options[:interval].to_i, 1].max
    end

    def weekdays
      IceCube::TimeUtil::DAYS.keys.select{ |day| @options[day].to_i == 1 }
    end

    def yearly_months
      y1 = Date.current.year
      y2 = start_month > end_month ? y1+1 : y1
      range = Date.new(y1,start_month,1)..Date.new(y2,end_month,1)
      range.group_by(&:month).keys
    end

    def start_month?
      @options[:yearly_start_month].present?
    end

    def end_month?
      @options[:yearly_end_month].present?
    end

    def start_day?
      @options[:yearly_start_month_day].present?
    end

    def end_day?
      @options[:yearly_end_month_day].present?
    end

    def start_month
      param_to_month @options[:yearly_start_month], 1
    end

    def end_month
      param_to_month @options[:yearly_end_month], 12
    end

    def start_day
      param_to_day @options[:yearly_start_month_day], 1
    end

    def end_day
      param_to_day @options[:yearly_end_month_day], 31
    end

    def param_to_month(param, default)
      (param.to_i % 12).tap { |m| return default if m == 0 }
    end

    def param_to_day(param, default)
      (param.to_i % 31).tap { |d| return default if d == 0 }
    end
  end
end
