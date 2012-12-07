require 'schedule_attributes/time_helpers'

module ScheduleAttributes
  module RuleParser
    TimeHelpers = ScheduleAttributes::TimeHelpers

    def self.[](interval)
      parser_name = interval.to_s.capitalize
      if parser_name.present? && RuleParser.const_defined?(parser_name)
        RuleParser.const_get parser_name
      end
    end

    def self.parse(options)
      new(options).parse
    end

  end
end

require 'schedule_attributes/rule_parser/base'
require 'schedule_attributes/rule_parser/day'
require 'schedule_attributes/rule_parser/week'
require 'schedule_attributes/rule_parser/month'
require 'schedule_attributes/rule_parser/year'
