module ScheduleAttributes
  class Configuration

    attr_accessor :time_format

    def initialize
      @time_format = '%H:%M %p'
    end
  end
end
