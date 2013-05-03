require 'ice_cube'

module ScheduleAttributes
  class Serializer

    # Only load YAML serializations that are present, not empty strings
    # An invalid value can raise an error that gets caught by ActiveRecord
    # and results in the original string getting passed through. This allows
    # it to be saved back unchanged if necessary.
    #
    def self.load(yaml)
      IceCube::Schedule.from_yaml(yaml) if yaml.present?
    end

    # This should normally receive a Schedule object.
    # In some unknown circumstance that I can't reproduce, it would save an
    # already-dumped serialized YAML Schedule string into a YAML string
    # wrapper, effectively double-bagging the YAML. I only assume it receives a
    # String when loading a bad YAML value from the database, which then
    # propagates and re-re-serializes itself into YAML on every save.
    #
    def self.dump(schedule)
      case schedule
      when IceCube::Schedule then schedule.to_yaml
      when String            then schedule
      end
    end

  end
end
