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

      NotificationMailer.applicant_request(applicant.crafter, applicant).deliver

      applicant
    rescue Exception => error
      NotificationMailer.dispatcher_failed_to_assign_applicant(applicant, error).deliver
    end

    def assign_applicant_specific(crafter_name)
      specified_crafter = crafter_repository.find_by_name(crafter_name)
      create_assignment(specified_crafter)

      NotificationMailer.applicant_request(applicant.crafter, applicant).deliver

      applicant
    rescue Exception => error
      NotificationMailer.dispatcher_failed_to_assign_applicant(applicant, error).deliver

    end

    private

    def best_applicant_reviewer
      finder = FindBestApplicantReviewer.new(applicant: applicant, fallback: steward)

      finder.call(candidates: all_crafters)
    end

    def create_assignment(crafter)
      applicant.update_attributes(:assigned_crafter => crafter.name)

      crafter_assignment_repository.create(
        :applicant_id => applicant.id,
        :crafter_id => crafter.id)
    end

    def all_crafters
      crafter_repository.all
    end

    def crafter_repository
      Footprints::Repository.crafter
    end

    def crafter_assignment_repository
      Footprints::Repository.assigned_crafter_record
    end
  end
end
