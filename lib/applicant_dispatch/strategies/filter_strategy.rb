require 'active_support/core_ext/object/try'
require 'delegate'

module ApplicantDispatch
  module Strategies
    class FilterStrategy < Struct.new(:filter)
      def call(candidates, applicant)
        sorted_candidates = filter.call(candidates, applicant)

        yield sorted_candidates
      end
    end
  end

  module Filters
    AvailabilityFilter = ->(craftsmen, applicant) {
      craftsmen.reject do |craftsman|
        craftsman.unavailable_until && craftsman.unavailable_until >= Date.today
      end
    }

    DisciplineFilter = ->(craftsmen, applicant) {
      craftsmen.select do |craftsman|
        position = craftsman.position

        !position or position.downcase == "software craftsman"
      end
    }

    LocationFilter = ->(craftsmen, applicant) {
      craftsmen.reject do |craftsman|
        craftsman.location.try(:downcase) != applicant.location.try(:downcase)
      end
    }

    PreviouslyDeniedFilter = ->(craftsmen, applicant) {
      craftsmen.reject do |craftsman|
        craftsman.previously_denied_applicant?(applicant)
      end
    }
  end
end
