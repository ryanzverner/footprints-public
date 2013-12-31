module ApplicantDispatch
  module Strategies
    class DefaultAllDesignApplicants
      LEAD_DESIGNER_EMAIL = "stephanie@abcinc.com"

      def call(candidates, applicant)
        if applicant.discipline.downcase == "designer"
          candidates.select { |candidate|
            candidate.email.downcase == LEAD_DESIGNER_EMAIL
          }.first
        else
          yield candidates
        end
      end
    end
  end
end
