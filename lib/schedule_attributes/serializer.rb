module ScheduleAttributes
  class Serializer
    def self.load(yaml)
      IceCube::Schedule.from_yaml(yaml) if yaml
    end

    def self.dump(schedule)
      schedule.to_yaml if schedule
    end
  end
end
