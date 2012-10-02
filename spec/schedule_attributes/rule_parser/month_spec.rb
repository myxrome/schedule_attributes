require 'spec_helper'
require 'pry'
require 'ice_cube'
require 'schedule_attributes/rule_parser'

describe ScheduleAttributes::RuleParser::Month do
  let(:parser) { ScheduleAttributes::RuleParser::Month }

  describe "#parse" do
    subject { parser.new(example.metadata[:args]).parse }

    context args: {} do
      it { should == IceCube::Rule.monthly }
    end

    context args: {"start_date" => "2012-03-14", "interval" => "2"} do
      it { should == IceCube::Rule.monthly(2) }
    end

    context args: {"ordinal_unit" => "day", "ordinal_day" => "14"} do
      it { should == IceCube::Rule.monthly.day_of_month(14) }
    end

    pending args: {"ordinal_unit" => "week", "ordinal_week" => "2", "tuesday" => "1"} do
      it { should == IceCube::Rule.monthly.day_of_week(:tuesday => 2) }
    end

    context args: {"start_date" => "2012-03-14", "end_date" => "2012-06-14"} do
      it { should == IceCube::Rule.monthly.until(Time.new(2012,6,14)) }
    end
  end
end
