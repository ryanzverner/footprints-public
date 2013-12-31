class ApplicantFlashPresenter
  def self.flash_message(applicant, action)
     if applicant.save
      flash[:notice] = "Successfully added new applicant."
      redirect_to "/applicants/#{applicant.id}"
    else
      flash[:error] = applicant.errors.full_messages
      flash[:errors_list] = applicant.errors.messages
      redirect_to "/applicants/new"
    end
  end
end
