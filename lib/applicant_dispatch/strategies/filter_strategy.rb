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
    AvailabilityFilter = ->(crafters, applicant) {
      crafters.reject do |crafter|
        crafter.unavailable_until && crafter.unavailable_until >= Date.today
      end
    }

    DisciplineFilter = ->(crafters, applicant) {
      crafters.select do |crafter|
        position = crafter.position

        !position or position.downcase == "software crafter"
      end
    }

    LocationFilter = ->(crafters, applicant) {
      crafters.reject do |crafter|
        crafter.location.try(:downcase) != applicant.location.try(:downcase)
      end
    }

    PreviouslyDeniedFilter = ->(crafters, applicant) {
      crafters.reject do |crafter|
        crafter.previously_denied_applicant?(applicant)
      end
    }
  end
end
