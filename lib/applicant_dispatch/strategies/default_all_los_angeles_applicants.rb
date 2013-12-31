module ApplicantDispatch
  module Strategies
    class DefaultAllLosAngelesApplicants
      LOS_ANGELES_DIRECTOR_EMAIL = "dave@abcinc.com"

      def call(candidates, applicant)
        location = applicant.location

        if location && location.downcase == "los angeles"
          candidates.select { |candidate| 
            candidate.email.downcase == LOS_ANGELES_DIRECTOR_EMAIL 
          }.first
        else
          yield candidates
        end
      end
    end
  end
end
