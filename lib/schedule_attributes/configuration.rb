module ScheduleAttributes

  class Configuration

    attr_accessor :time_format

    def initialize
      @time_format = '%H:%M'
    end
  end

  class << self
    def configure
      @configuration ||= Configuration.new
      if block_given?
        yield @configuration
      end
      return @configuration
    end
    alias_method :configuration, :configure
  end
end
