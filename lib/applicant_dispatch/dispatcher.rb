require 'repository'

require 'applicant_dispatch/find_best_applicant_reviewer'

module ApplicantDispatch
  class Dispatcher
    attr_reader :applicant, :steward

    def initialize(applicant, steward)
      @applicant = applicant
      @steward = steward
    end

    def assign_applicant
      create_assignment(best_applicant_reviewer)

      NotificationMailer.applicant_request(applicant.craftsman, applicant).deliver

      applicant
    rescue Exception => error
      NotificationMailer.dispatcher_failed_to_assign_applicant(applicant, error).deliver
    end

    private

    def best_applicant_reviewer
      finder = FindBestApplicantReviewer.new(applicant: applicant, fallback: steward)

      finder.call(candidates: all_craftsmen)
    end

    def create_assignment(craftsman)
      applicant.update_attributes(:assigned_craftsman => craftsman.name)

      craftsman_assignment_repository.create(
        :applicant_id => applicant.id,
        :craftsman_id => craftsman.id)
    end

    def all_craftsmen
      craftsman_repository.all
    end

    def craftsman_repository
      Footprints::Repository.craftsman
    end

    def craftsman_assignment_repository
      Footprints::Repository.assigned_craftsman_record
    end
  end
end
