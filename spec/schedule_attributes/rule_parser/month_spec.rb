require 'spec_helper'
require 'ice_cube'
require 'schedule_attributes/rule_parser'
require 'schedule_attributes/input'

describe ScheduleAttributes::RuleParser::Month do

  describe "#rule" do
    let(:input)  { ScheduleAttributes::Input.new(example.metadata[:args]) }
    let(:parser) { described_class.new(input) }
    subject      { parser.rule }

    let(:t) { Date.current }
    let(:n) { (t-14 >> 1).change(day: 14) }

    let(:monthly)    { [t, t >> 1, t >> 2, t >> 3].map(&:to_time) }
    let(:bimonthly)  { [t, t >> 2, t >> 4, t >> 6].map(&:to_time) }
    let(:every_14th) { [n, n >> 1, n >> 2, n >> 3].map(&:to_time) }

    context args: {} do
      it { should == IceCube::Rule.monthly }
      its_occurrences_until(3.months.from_now) { should == monthly }
    end

    context args: {"start_date" => "2000-03-14", "interval" => "2"} do
      it { should == IceCube::Rule.monthly(2) }
      its_occurrences_until(6.months.from_now) { should == bimonthly }
    end

    context args: {"ordinal_unit" => "day", "ordinal_day" => "14"} do
      it { should == IceCube::Rule.monthly.day_of_month(14) }
      its_occurrences_until(4.months.from_now) { should == every_14th }
    end

    context args: {"ordinal_unit" => "week", "ordinal_week" => "2", "tuesday" => "1"}, pending: "Add support for :ordinal_week attribute" do
      it { should == IceCube::Rule.monthly.day_of_week(:tuesday => 2) }
    end

    context args: {"start_date" => "2000-03-14", "end_date" => "2000-06-14"} do
      it { should == IceCube::Rule.monthly.until(Time.new(2000,6,14)) }
    end
  end
end
