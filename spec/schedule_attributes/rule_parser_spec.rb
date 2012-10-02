require 'spec_helper'
require 'schedule_attributes/rule_parser'

describe ScheduleAttributes::RuleParser do
  describe "class methods" do
    {
      "day" => ScheduleAttributes::RuleParser::Day,
      "week" => ScheduleAttributes::RuleParser::Week,
      "month" => ScheduleAttributes::RuleParser::Month,
      "year" => ScheduleAttributes::RuleParser::Year
    }. each do |key,parser_class|

      it "returns parser for #{key} interval units" do
        ScheduleAttributes::RuleParser[key].should == parser_class
      end
    end
  end
end
