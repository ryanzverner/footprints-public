module Footprints
  class ApplicantArchiver
    class << self

      def archive_neglected_applicants
        get_neglected_applicants.each do |applicant|
          applicant.archived = true
          applicant.save!
        end
      end

      private

      def get_neglected_applicants
        unarchived_applicants = find_unarchived_applicants
        unarchived_applicants.select { |applicant| neglected?(applicant) }
      end

      def find_unarchived_applicants
        Applicant.where(:archived => false)
      end

      def neglected?(applicant)
        state = ApplicantStateMachine.determine_state(applicant)
        date_since_last_action = applicant.send(state)
        date_since_last_action <= DateTime.current - 3.months
      end

    end
  end
end
