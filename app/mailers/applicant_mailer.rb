class ApplicantMailer < ActionMailer::Base
  default :from => "recruiter@abcinc.com",
    :reply_to => "noreply@abcinc.com",
    :bcc => "dropbox@92013697.abcinc.highrisehq.com"

  def email_applicant(applicant, email_body)
    @applicant = applicant
    mail(to: @applicant.email,
         body: email_body,
         content_type: "text/html",
         subject: "ABC, Inc. Apprenticeship")
  end
end
