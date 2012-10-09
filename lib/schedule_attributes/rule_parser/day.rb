module ScheduleAttributes::RuleParser
  class Day < Base

    # @return [IceCube::Rule]
    #
    def parse_options
      @rule = rule_factory.daily(interval)
    end
  end
end
