require 'ar_repository/models/applicant'
require 'ar_repository/base_repository'

module ArRepository
  class ApplicantRepository
    include BaseRepository
    include ApplicantsHelper

    def model_class
      ::Applicant
    end

    def create(attributes = {})
      begin
        applicant = model_class.new(attributes)
        applicant.save!
        applicant
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => invalid
        raise Footprints::RecordNotValid.new(applicant)
      end
    end

    def find_by_name(name)
      model_class.find_by_name(name)
    end

    def find_by_email(email)
      model_class.find_by_email(email)
    end

    def find_by_id(id)
      model_class.find_by_id(id)
    end

    def where(query_string, query)
      model_class.where(query_string, query)
    end

    def find_like(term)
      result = where("name like ?","%#{term}%")
      result.empty? ? where("name like ?","%#{term}%") : result
    end

    def get_all_archived_applicants
      model_class.where(:archived => true).order('applied_on DESC')
    end

    def get_all_unarchived_applicants
      model_class.where(:archived => false).order('applied_on DESC')
    end

    def get_unassigned_unarchived_applicants
      model_class.where(:assigned_craftsman => nil, :archived => false)
    end

    def get_applicants_by_state(state)
      all.select do |applicant|
        ApplicantStateMachine.determine_state(applicant) == state
      end
    end
  end
end
