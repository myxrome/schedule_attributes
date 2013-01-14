require 'spec_helper'
require 'support/scheduled_active_record_model'


describe CustomScheduledActiveRecordModel do

  it "should have a default schedule" do
    subject.my_schedule.should == hourly
  end

  def hourly
    IceCube::Schedule.new(Date.today.to_time).tap { |s|
      s.add_recurrence_rule IceCube::Rule.hourly
    }
  end

end

describe DefaultScheduledActiveRecordModel do

  it "should have a default schedule" do
    subject.schedule.should be_a IceCube::Schedule
  end

end
