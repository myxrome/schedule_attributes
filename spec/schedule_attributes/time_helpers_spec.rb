require 'spec_helper'
require 'schedule_attributes/time_helpers'
require 'active_support/time_with_zone'

describe ScheduleAttributes::TimeHelpers do
  describe '.parse_in_zone' do
    context "with time zone" do
      before { Time.zone = 'UTC' }
      it "returns a time from a date string" do
        subject.parse_in_zone("2012-12-31").should == Time.zone.parse("2012-12-31")
      end

      it "returns a time from a time" do
        subject.parse_in_zone(Time.new(2012,12,31)).should == Time.zone.parse("2012-12-31")
      end

      it "returns a time from a date" do
        subject.parse_in_zone(Date.new(2012,12,31)).should == Time.zone.parse("2012-12-31")
      end
    end

    context "without ActiveSupport" do
      it "returns a time from a date string" do
        subject.parse_in_zone("2012-12-31").should == Time.parse("2012-12-31")
      end

      it "returns a time from a time" do
        subject.parse_in_zone(Time.new(2012,12,31)).should == Time.parse("2012-12-31")
      end
    end
  end
end
