require 'spec_helper'
require 'schedule_attributes/configuration'

describe "ScheduleAttributes" do
  describe ".configure" do
    it "yields a configuration instance" do
      ScheduleAttributes.configure do |config|
        config.should be_a ScheduleAttributes::Configuration
      end
    end

    it "returns a configuration instance" do
      ScheduleAttributes.configure.should be_a ScheduleAttributes::Configuration
    end
  end
end

describe ScheduleAttributes::Configuration do
  its(:time_format) { should == '%H:%M' }

  it "#time_format is settable" do
    subject.time_format = '%l:%M %P'
    subject.time_format.should == '%l:%M %P'
  end
end
