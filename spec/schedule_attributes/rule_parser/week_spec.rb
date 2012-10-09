require 'spec_helper'
require 'ice_cube'
require 'schedule_attributes/rule_parser'

describe ScheduleAttributes::RuleParser::Week do
  let(:t)   { Date.current.to_time }
  let(:sun) { (Date.current - Date.current.cwday.days).to_time + 1.week }
  let(:mon) { sun + 1.day }
  let(:sat) { sun - 1.day }

  let(:weekly)        { [t, t+1.week, t+2.weeks, t+3.weeks, t+4.weeks, t+5.weeks] }
  let(:every_2_weeks) { [t, t+2.week, t+4.weeks]}
  let(:weekends)      { [sat, sun, sat+1.week, sun+1.week, sat+2.weeks, sun+2.weeks] }

  describe "#rule" do
    let(:parser) { described_class.new(example.metadata[:args]) }
    subject      { parser.rule }

    context args: {} do
      it { should == IceCube::Rule.weekly }
      its_occurrences_until(5.weeks.from_now) { should == weekly }
    end

    context args: {"interval" => "2"} do
      it { should == IceCube::Rule.weekly(2) }
      its_occurrences_until(5.weeks.from_now) { should == every_2_weeks }
    end

    context args: {"monday" => "0", "saturday" => "1", "sunday" => "1"} do
      it { should == IceCube::Rule.weekly.day(0,6) }
      its_occurrences_until(Date.today.beginning_of_week+3.weeks) { subject[-4..-1].should == weekends[-4..-1] }
    end
  end
end
