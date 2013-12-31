require 'applicant_dispatch/dispatcher'

class EighthlightApplicantsInteractor
  class << self
    def apply(params)
      if repo.applicant.find_by_email(params[:email])
        body = "Duplicate Applicant"
        status = 422
      else
        applicant = repo.applicant.new(params)

        if applicant.valid?
          applicant.save!
          status = 200
        else
          body = applicant.errors.full_messages.join(", ")
          status = 400
        end
      end

      [status, body]
    end

    private

    def repo
      Footprints::Repository
    end
  end
end
