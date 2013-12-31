module ApplicantDispatch
  module Strategies
    class DefaultAllLondonApplicants
      LONDON_DIRECTOR_EMAIL = "jim@abcinc.com"

      def call(candidates, applicant)
        location = applicant.location

        if location && location.downcase == "london"
          candidates.select { |candidate| 
            candidate.email.downcase == LONDON_DIRECTOR_EMAIL
          }.first
        else
          yield candidates
        end
      end
    end
  end
end
