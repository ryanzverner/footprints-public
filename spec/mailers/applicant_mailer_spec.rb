require "spec_helper"

describe ApplicantMailer do
  describe "#email_applicant" do
    let(:applicant) { mock_model Applicant, name: "Test", email: 'test@test.com', applied_on: Date.today }
    let(:mail) { ApplicantMailer.email_applicant(applicant, "Email body") }

    it "renders the subject" do
      expect(mail.subject).to eq( "ABC, Inc. Apprenticeship")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([applicant.email])
    end

    it "renders the send email" do
      expect(mail.from).to eq(['recruiter@abcinc.com'])
    end

    it "renders the bcc email" do
      expect(mail.bcc).to eq(["dropbox@92013697.abcinc.highrisehq.com"])
    end

    it "renders the body" do
      expect(mail.body).to eq("Email body")
    end
  end
end
