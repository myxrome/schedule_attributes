require 'spec_helper'
require 'schedule_attributes/input'

describe ScheduleAttributes::Input do
  let(:input) { described_class.new(example.metadata[:args]) }

  describe "#repeat?" do
    subject(:repeat) { input.repeat? }

    context args: {} do
      it { should be true }
    end

    [0, '0', 'false', 'f', 'F', 'no', 'none'].each do |cond|
      context args: {repeat: cond} do
        it { should be false }
      end
    end

    [1, '1', 'true', 't', 'T', 'yes', 'whatever'].each do |cond|
      context args: {repeat: cond} do
        it { should be true }
      end
    end
  end

  describe "#start_time" do
    subject(:start_time) { input.start_time }

    context args: {} do
      it { should be nil }
    end

    context args: {date: '2000-12-31'} do
      it { should == Time.new(2000,12,31,0,0,0) }
    end

    context args: {start_date: '2000-12-31'} do
      it { should == Time.new(2000,12,31,0,0,0) }
    end

    context args: {date: '2000-06-06', start_date: '2000-12-31'} do
      it { should == Time.new(2000,12,31,0,0,0) }
    end

    context args: {repeat: '0', date: '2000-06-06', start_date: '2000-12-31'} do
      it "uses date instead of start_date when not repeating" do
        should == Time.new(2000,6,6,0,0,0)
      end
    end

    context args: {start_date: '2000-12-31', start_time: '14:30'} do
      it "combines start_date and start_time" do
        should == Time.new(2000,12,31,14,30,0)
      end
    end

    context args: {start_time: '14:00'} do
      it { should == Date.today.to_time + 14.hours }
    end
  end

  describe "#end_time" do
    subject(:end_time) { input.end_time }

    context args: {} do
      it { should be nil }
    end

    context args: {end_time: '14:00'} do
      it { should == Date.today.to_time + 14.hours }
    end

    context args: {start_date: '2000-12-31', end_time: '14:00'} do
      it { should == Time.new(2000,12,31,14,0,0) }
    end

    context args: {start_date: '2000-06-06', end_date: '2000-12-31', end_time: '14:00'} do
      it { should == Time.new(2000,6,6,14,0,0) }
    end

    context args: {date: '2000-12-31', end_time: '14:00'} do
      it { should == Time.new(2000,12,31,14,0,0) }
    end
  end

  describe "#duration" do
    subject(:duration) { input.duration }

    context args: {} do
      it { should be nil }
    end

    context args: {start_time: '8:00'} do
      it { should be nil }
    end

    context args: {start_time: '8:00', end_time: '14:00'} do
      it { should == 6.hours }
    end
  end

  describe "#dates" do
    subject(:dates) { input.dates }

    context args: {} do
      it { should == [] }
    end

    context args: {repeat: '0'} do
      it { should == [] }
    end

    context args: {start_date: '2000-06-06'} do
      it { should == [] }
    end

    context args: {repeat: '0', date: '2000-06-06', start_date: '2000-02-03'} do
      it { should == [Time.new(2000,6,6)] }
    end

    context args: {dates: ['2000-01-02','2000-02-03']} do
      it { should == [Time.new(2000,1,2), Time.new(2000,2,3)] }
    end

    context args: {repeat: '0', date: '2000-06-06', start_date: '2000-06-06', start_time: '12:00'} do
      it { should == [Time.new(2000,6,6,12,0)] }
    end
  end

  describe "#ends?" do
    subject(:ends) { input.ends? }

    context args: {repeat: '1', end_date: ''} do
      it { should be_false }
    end
  end
end
