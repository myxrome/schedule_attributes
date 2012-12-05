module ScheduleAttributes::RuleParser
  class Day < Base

    private

    # @return [IceCube::Rule]
    #
    def parse_options
      @rule = rule_factory.daily(input.interval)
    end

  end
end
