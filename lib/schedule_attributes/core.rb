require 'active_support'
require 'active_support/concern'
require 'active_support/time_with_zone'
require 'ice_cube'
require 'ostruct'
require 'schedule_attributes/extensions/ice_cube'
require 'schedule_attributes/time_helpers'
require 'schedule_attributes/rule_parser'

module ScheduleAttributes
  DEFAULT_ATTRIBUTE_KEY = :schedule_yaml
  DAY_NAMES = Date::DAYNAMES.map(&:downcase).map(&:to_sym)

  def self.parse_rule(options)
    RuleParser[options[:interval_unit]].parse(options)
  end

  module Core
    extend ActiveSupport::Concern

    def schedule
      @schedule ||= begin
        unless (serialization = read_schedule_attributes).blank?
          IceCube::Schedule.from_yaml(serialization)
        else
          IceCube::Schedule.new(Date.today.to_time).tap do |s|
            s.add_recurrence_rule(IceCube::Rule.daily)
          end
        end
      end
    end

    def schedule_attributes=(options)
      options = options.with_indifferent_access
      options[:interval] = options.fetch(:interval, 1).to_i

      repeat = [false, 0, "false", "0", "none"].none? { |v| options[:repeat] == v }

      date_input = if repeat
                     options[:dates] ? options[:dates].first : options[:date]
                   else
                     options[:start_date]
                   end

      options[:start_time] &&= ScheduleAttributes::TimeHelpers.parse_in_zone([date_input, options[:start_time]].reject(&:blank?).join(' '))
      options[:end_time] &&= ScheduleAttributes::TimeHelpers.parse_in_zone([date_input, options[:end_time]].reject(&:blank?).join(' '))
      if options[:start_time] && options[:end_time]
        options[:duration] = options[:end_time] - options[:start_time]
      end

      if repeat
        @schedule = IceCube::Schedule.new(options[:start_time])

        rule = ScheduleAttributes::RuleParser[options[:interval_unit]].new(options)
        @schedule.add_recurrence_rule(rule.parse) if rule
      else
        dates = (options[:dates] || [options[:date]]).map do |d|
          ScheduleAttributes::TimeHelpers.parse_in_zone([d, options[:start_time]].reject(&:blank?).join(' '))
        end

        @schedule = IceCube::Schedule.new(dates.first)

        dates.each { |d| @schedule.add_recurrence_time(d) }
      end

      @schedule.duration = options[:duration] if options[:duration]

      write_schedule_attributes(@schedule.to_yaml)
    end

    def schedule_attributes
      atts = {}

      atts[:start_time] = schedule.start_time.strftime('%H:%M %p')
      atts[:end_time]   = (schedule.start_time + schedule.duration.to_i).strftime('%H:%M %p')

      if rule = schedule.rrules.first
        atts[:repeat]     = 1
        atts[:start_date] = schedule.start_time.to_date
        atts[:date]       = Date.today # default for populating the other part of the form

        rule_hash = rule.to_hash
        atts[:interval] = rule_hash[:interval]

        case rule
        when IceCube::DailyRule
          atts[:interval_unit] = 'day'
        when IceCube::WeeklyRule
          atts[:interval_unit] = 'week'

          if rule_hash[:validations][:day]
            rule_hash[:validations][:day].each do |day_idx|
              atts[ ScheduleAttributes::DAY_NAMES[day_idx] ] = 1
            end
          end
        when IceCube::MonthlyRule
          atts[:interval_unit] = 'month'

          day_of_week = rule_hash[:validations][:day_of_week]
          day_of_month = rule_hash[:validations][:day_of_month]

          if day_of_week
            day_of_week = day_of_week.first.flatten
            atts[:ordinal_week] = day_of_week.first
            atts[:ordinal_unit] = 'week'
          elsif day_of_month
            atts[:ordinal_day]  = day_of_month.first
            atts[:ordinal_unit] = 'day'
          end
        end

        if rule.until_time
          atts[:end_date] = rule.until_time.to_date
          atts[:ends] = 'eventually'
        else
          atts[:ends] = 'never'
        end
      else
        atts[:repeat]     = 0
        atts[:interval]   = 1
        atts[:date]       = schedule.start_time.to_date
        atts[:start_date] = Date.today # default for populating the other part of the form
      end

      OpenStruct.new(atts)
    end

    protected

    def read_schedule_attributes_column
      public_method(self.class.schedule_column).call
    end

    def write_schedule_attributes_column(value)
      public_method("#{self.class.schedule_column}=").call(value)
    end
  end
end
