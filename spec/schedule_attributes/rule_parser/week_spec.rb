require 'spec_helper'
require 'pry'
require 'ice_cube'
require 'schedule_attributes/rule_parser'

describe ScheduleAttributes::RuleParser::Week do
  let(:parser) { ScheduleAttributes::RuleParser::Week }

  describe "#parse" do
    subject { parser.new(example.metadata[:args]).parse }

    context args: {} do
      it { should == IceCube::Rule.weekly }
    end

    context args: {"interval" => "2"} do
      it { should == IceCube::Rule.weekly(2) }
    end
  end
end
