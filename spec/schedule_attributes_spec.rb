require 'spec_helper'
require 'support/scheduled_model'

describe ScheduledModel do

  describe "#schedule" do
    subject(:schedule) { ScheduledModel.new.schedule }

    it "should default to a daily schedule" do
      schedule.should be_a(IceCube::Schedule)
      schedule.rtimes.should == []
      schedule.start_time.should == Date.today.to_time
      schedule.end_time.should be nil
      schedule.rrules.should == [IceCube::Rule.daily]
    end
  end

  describe "#schedule_attributes=" do
    describe "setting the correct schedule" do
      let(:scheduled_model) { ScheduledModel.new.tap { |m| m.schedule_attributes = example.metadata[:args] } }
      subject(:schedule)    { scheduled_model.schedule }

      context args: {repeat: '0', date: '1-1-1985', interval: '5 (ignore this)'} do
        its(:start_time)      { should == Time.new(1985,1,1) }
        its(:all_occurrences) { should == [Time.new(1985,1,1)] }
        its(:rrules)          { should be_blank }
      end

      context args: {repeat: '0', dates: ['1-1-1985', '31-12-1985'], interval: '5 (ignore this)'} do
        its(:start_time)      { should == Time.new(1985,1,1) }
        its(:all_occurrences) { should == [Time.new(1985,1,1), Time.new(1985,12,31)] }
        its(:rrules)          { should be_blank }
      end

      context args: {repeat: '0', dates: ['1-1-1985', '31-12-1985'], start_time: '12:00', end_time: '14:00', interval: '5 (ignore this)'} do
        its(:start_time)      { should == Time.new(1985,1,1,12,0) }
        its(:duration)        { should == 7200 }
        its(:all_occurrences) { should == [Time.new(1985,1,1,12,0), Time.new(1985,12,31,12,0)] }
        its(:rrules)          { should be_blank }
        specify               { schedule.occurring_between?(helpers.parse_in_zone('1985-1-1 12:00'), helpers.parse_in_zone('1985-6-25 14:00')).should be_true }
        specify               { schedule.occurs_at?(helpers.parse_in_zone('1985-1-1 12:00')).should be_true }
        specify               { schedule.occurs_at?(helpers.parse_in_zone('1985-6-6 15:00')).should be_false }
      end

      context args: {repeat: '1'} do
        its(:start_time) { should == Date.today.to_time }
        its(:rrules)     { should == [IceCube::Rule.daily] }
      end

      context args: {repeat: '1', start_date: '1-1-1985', interval_unit: 'day', interval: '3'} do
        its(:start_time) { should == Date.new(1985,1,1).to_time }
        its(:rrules)     { should == [IceCube::Rule.daily(3)] }
        specify          { schedule.first(3).should == [Date.civil(1985,1,1), Date.civil(1985,1,4), Date.civil(1985,1,7)].map(&:to_time) }
      end

      context args: {repeat: "1", start_date: "1-1-1985", interval_unit: "day", interval: "3", end_date: "29-12-1985", ends: "eventually"} do
        its(:start_time) { should == Date.new(1985,1,1).to_time }
        its(:rrules)     { should == [ IceCube::Rule.daily(3).until(Date.new(1985,12,29).in_time_zone) ] }
        specify          { schedule.first(3).should == [Date.civil(1985,1,1), Date.civil(1985,1,4), Date.civil(1985,1,7)].map(&:to_time) }
      end

      context args: {repeat: '1', start_date: '1-1-1985', interval_unit: 'day', interval: '3', until_date: '29-12-1985', ends: 'never'} do
        its(:start_time) { should == Date.new(1985,1,1).to_time }
        its(:rrules)     { should == [IceCube::Rule.daily(3)] }
        specify          { schedule.first(3).should == [Date.civil(1985,1,1), Date.civil(1985,1,4), Date.civil(1985,1,7)].map(&:to_time) }
      end

      context args: {repeat: '1', start_date: '1-1-1985', interval_unit: 'week', interval: '3', monday: '1', wednesday: '1', friday: '1'} do
        its(:start_time) { should == Date.new(1985,1,1).to_time }
        its(:rrules)     { should == [IceCube::Rule.weekly(3).day(:monday, :wednesday, :friday)] }
        specify          { schedule.occurs_at?(helpers.parse_in_zone('1985-1-2')).should be_true }
        specify          { schedule.occurs_at?(helpers.parse_in_zone('1985-1-4')).should be_true }
        specify          { schedule.occurs_at?(helpers.parse_in_zone('1985-1-7')).should be_false }
        specify          { schedule.occurs_at?(helpers.parse_in_zone('1985-1-21')).should be_true }
      end

      context args: {repeat: '1', start_date: '1-1-1985', interval_unit: 'day'} do
        its(:rrules) { should == [IceCube::Rule.daily(1)] }
      end

      context args: {repeat: '1', start_date: '1-1-1985', interval_unit: 'year'} do
        its(:start_time) { should == Date.new(1985,1,1).to_time }
        its(:rrules)     { should == [IceCube::Rule.yearly.day_of_month(1).month_of_year(1)] }
        specify          { schedule.first(3).should == [Date.civil(1985,1,1), Date.civil(1986,1,1), Date.civil(1987,1,1)].map(&:to_time) }
      end

      context args: {repeat: '1', interval_unit: 'day', start_date: '2012-09-27', yearly_start_month: '12', yearly_start_month_day: '1', yearly_end_month: '4', yearly_end_month_day: '21'} do
        its(:start_time) { should == Time.new(2012,9,27) }
        its(:rrules)     { should == [IceCube::Rule.daily.month_of_year(12,1,2,3,4)] }
        its(:exrules)    { should == [IceCube::Rule.daily.month_of_year(4).day_of_month(*22..31)] }
      end

      context "all_day", pending: "Work in progress"
    end

    describe "setting the schedule field", args: {repeat: '1', start_date: '1-1-1985', interval_unit: 'day', interval: '3'} do
      let(:scheduled_model) { ScheduledModel.new.tap { |m| m.schedule_attributes = example.metadata[:args] } }
      subject               { scheduled_model }

      its(:schedule) { should == IceCube::Schedule.new(Date.new(1985,1,1).to_time).tap { |s| s.add_recurrence_rule IceCube::Rule.daily(3) }  }
    end

  end

  describe "schedule_attributes" do
    let(:scheduled_model) { ScheduledModel.new }
    let(:schedule)        { IceCube::Schedule.new(Date.tomorrow.to_time) }
    subject               { scheduled_model.schedule_attributes }
    before                { scheduled_model.stub(schedule: schedule) }

    context "for a single date" do
      before { schedule.add_recurrence_time(Date.tomorrow.to_time) }
      it     { should == OpenStruct.new(repeat: 0, interval: 1, date: Date.tomorrow, dates: [Date.tomorrow], start_date: Date.today, all_day: true) }
      its(:date) { should be_a(Date) }
    end

    context "when it repeats daily" do
      before do
        schedule.add_recurrence_rule(IceCube::Rule.daily(4))
      end
      it { should == OpenStruct.new(repeat: 1, start_date: Date.tomorrow, interval_unit: 'day', interval: 4, ends: 'never', date: Date.today, all_day: true) }
      its(:start_date){ should be_a(Date) }
    end

    context "when it repeats with an end date" do
      before do
        schedule.add_recurrence_rule(IceCube::Rule.daily(4).until((Date.today+10).to_time))
      end
      it { should == OpenStruct.new(repeat: 1, start_date: Date.tomorrow, interval_unit: 'day', interval: 4, ends: 'eventually', end_date: Date.today+10, date: Date.today, all_day: true) }
      its(:start_date){ should be_a(Date) }
      its(:end_date){ should be_a(Date) }
    end

    context "when it repeats weekly" do
      before do
        schedule.add_recurrence_time(Date.tomorrow)
        schedule.add_recurrence_rule(IceCube::Rule.weekly(4).day(:monday, :wednesday, :friday))
      end
      it do
        should == OpenStruct.new(
          :repeat        => 1,
          :start_date    => Date.tomorrow,
          :interval_unit => 'week',
          :interval      => 4,
          :ends          => 'never',
          :monday        => 1,
          :wednesday     => 1,
          :friday        => 1,
          :all_day       => true,

          :date          => Date.today #for the form
        )
      end
    end

    context "when it repeats yearly" do
      before do
        schedule.add_recurrence_time(Date.tomorrow)
        schedule.add_recurrence_rule(IceCube::Rule.yearly)
      end
      it do
        should == OpenStruct.new(
          :repeat        => 1,
          :start_date    => Date.tomorrow,
          :interval_unit => 'year',
          :interval      => 1,
          :ends          => 'never',
          :all_day       => true,

          :date          => Date.today #for the form
        )
      end
    end

    context "when it has yearly date range" do
      it "should have yearly start and end months" do
        schedule.add_recurrence_rule(IceCube::Rule.daily.month_of_year(12,1,2))

        subject.yearly_start_month.should == 12
        subject.yearly_end_month.should == 2
      end

      it "should have a yearly start date" do
        schedule.add_recurrence_rule(IceCube::Rule.daily.month_of_year(11,12,1,2))
        schedule.add_exception_rule(IceCube::Rule.daily.month_of_year(11).day_of_month(*1..6))

        subject.yearly_start_month.should == 11
        subject.yearly_start_month_day.should == 7
      end

      it "should have a yearly end date" do
        schedule.add_recurrence_rule(IceCube::Rule.daily.month_of_year(1,2,3))
        schedule.add_exception_rule(IceCube::Rule.daily.month_of_year(3).day_of_month(*26..31))

        subject.yearly_end_month.should == 3
        subject.yearly_end_month_day.should == 25
      end

      it "should have no yearly start day for months only" do
        schedule.add_recurrence_rule(IceCube::Rule.daily.month_of_year(1,2,3))

        subject.yearly_start_month_day.should be_nil
      end

      it "should have a yearly start day on the first when end day is set" do
        schedule.add_recurrence_rule(IceCube::Rule.daily.month_of_year(1,2,3))
        schedule.add_exception_rule(IceCube::Rule.daily.month_of_year(3).day_of_month(*26..31))

        subject.yearly_start_month_day.should == 1
      end
    end

    context "all_day", pending: "Work in progress"
  end

  def helpers
    ScheduleAttributes::TimeHelpers
  end
end
