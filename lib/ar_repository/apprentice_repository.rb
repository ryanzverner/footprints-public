require 'ar_repository/models/applicant'
require 'ar_repository/base_repository'

module ArRepository
  class ApprenticeRepository
    include BaseRepository
    include ApprenticesHelper

    def model_class
      ::Apprentice
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

	end
end