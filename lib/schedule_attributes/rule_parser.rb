require 'schedule_attributes/time_helpers'

module ScheduleAttributes
  module RuleParser
    def self.[](interval)
      parser_name = interval.to_s.capitalize
      if RuleParser.const_defined? parser_name
        RuleParser.const_get parser_name
      else
        RuleParser::Day
      end
    end
  end
end

require 'schedule_attributes/rule_parser/day'
require 'schedule_attributes/rule_parser/week'
require 'schedule_attributes/rule_parser/month'
require 'schedule_attributes/rule_parser/year'
