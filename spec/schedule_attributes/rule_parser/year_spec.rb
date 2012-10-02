require 'spec_helper'
require 'pry'
require 'ice_cube'
require 'schedule_attributes/rule_parser'

describe ScheduleAttributes::RuleParser::Year do
  let(:parser) { ScheduleAttributes::RuleParser::Year }
  let(:rule)   { IceCube::Rule }

  describe "#parse" do
    subject { parser.new(example.metadata[:args]).parse }

    context args: {} do
      it { should be_nil }
    end

    context args: {"start_date" => "2012-01-30", "interval" => "2"} do
      it { should == rule.yearly(2).month_of_year(1).day_of_month(30) }
    end

    context args: {"start_date" => "2012-01-30"} do
      it { should == rule.yearly.month_of_year(1).day_of_month(30) }
    end

    context args: {"start_date" => "2012-01-30", "end_date" => "2014-01-30"} do
      it { should == rule.yearly.month_of_year(1).day_of_month(30).until(Time.new(2014,1,30)) }
    end
  end
end
