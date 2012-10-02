require 'spec_helper'
require 'pry'
require 'ice_cube'
require 'schedule_attributes/rule_parser'

describe ScheduleAttributes::RuleParser::Day do
  let(:parser) { ScheduleAttributes::RuleParser::Day }

  describe "#parse" do
    subject { parser.new(example.metadata[:args]).parse }

    context args: {} do
      it { should == IceCube::Rule.daily }
    end

    context args: {"interval" => "2"} do
      it { should == IceCube::Rule.daily(2) }
    end

    context args: {"end_date" => "2014-01-30"} do
      it { should == IceCube::Rule.daily.until(Time.new(2014,1,30)) }
    end
  end
end
