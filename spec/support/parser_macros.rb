module SpecHelpers
  module ParserMacros
    extend ActiveSupport::Concern

    module ClassMethods
      def its_occurrences_until(date, &block)
        describe("occurrences") do
          example do
            self.class.class_eval do
              define_method(:subject) do
                schedule = IceCube::Schedule.new(Date.current.to_time)
                schedule.add_recurrence_rule instance_eval(&self.class.subject)
                @_subject = schedule.occurrences(date)
              end
            end
            instance_eval(&block)
          end
        end
      end
    end
  end
end
