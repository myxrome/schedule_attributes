require 'spec_helper'
require 'support/scheduled_active_record_model'


describe ScheduledActiveRecordModel do
  it "should have a default schedule" do
    subject.my_schedule.should be_a IceCube::Schedule
  end

end

