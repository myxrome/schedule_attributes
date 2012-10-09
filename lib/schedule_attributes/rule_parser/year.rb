module ScheduleAttributes::RuleParser
  class Year < Base
    def parse_options
      @rule = rule_factory.yearly(interval).tap do |rule|
        case @options[:yearly_type]
        when "range"
          if start_day && start_month && end_day && end_month
            rule.day_of_year(start_yday, end_yday)
          end
        when "months"
        else
          if @options[:start_date]
            rule.month_of_year(start_date.month).day_of_month(start_date.day)
          end
        end
      end
    end

    private

    def start_yday
      Date.new(Date.current.year, start_month, start_day).yday
    rescue
    end

    def end_yday
      Date.new(Date.current.year, end_month, end_day).yday
    rescue
    end

    def start_month
      if @options[:yearly_start_month].present?
        TimeHelpers.parse_in_zone(@options[:yearly_start_month])
      # else
      #   start_date ? start_date.month : nil
      end
    end

    def end_month
      if @options[:yearly_end_month].present?
        TimeHelpers.parse_in_zone(@options[:yearly_end_month])
      # else
      #   end_date ? end_date.month : nil
      end
    end

    def start_day
      if @options[:yearly_start_month_day].present?
        TimeHelpers.parse_in_zone(@options[:yearly_start_month_day])
      end
    end

    def end_day
      if @options[:yearly_end_month_day].present?
        TimeHelpers.parse_in_zone(@options[:yearly_end_month_day])
      end
    end
  end
end
