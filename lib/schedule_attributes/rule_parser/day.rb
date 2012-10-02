module ScheduleAttributes::RuleParser
  class Day

    def self.parse(options)
      new(options).parse
    end

    # Daily rules don't actually use the start date, it's based on the start
    # date of the whole schedule the rule is attached to. However, rules can
    # have an "until" end date.
    #
    # @param [Hash] options
    # @option [String] :interval
    # @option [String] :end_date
    #
    def initialize(options)
      @options = options.with_indifferent_access
      @rule ||= rule_factory.daily(interval)
    end

    # @return [IceCube::Rule]
    #
    def parse
      if @options[:end_date].present? && @options[:ends] != 'never'
        @rule = @rule.until(end_date)
      end
      @rule
    end

    private

    def rule_factory
      IceCube::Rule
    end

    def start_date
      raise ArgumentError unless @options[:start_date]
      ScheduleAttributes::TimeHelpers.parse_in_timezone(@options[:start_date])
    end

    def end_date
      @options[:end_date].present? ? ScheduleAttributes::TimeHelpers.parse_in_timezone(@options[:end_date]) : nil
    end

    def interval
      [@options[:interval].to_i, 1].max
    end
  end
end
