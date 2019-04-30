require "spec_helper"

describe NotificationMailer do
  let(:applicant) { mock_model Applicant, name: "Applicant", skill: 'skill', first_name: "App", email: 'test@test.com', applied_on: Date.today }
  let(:crafter) { mock_model Crafter, name: "Crafter", first_name: "Craft", email: "crafter@abcinc.com", :employment_id => "12345" }

  describe "#applicant_request" do
    let(:mail) { NotificationMailer.applicant_request(crafter, applicant) }

    it "renders the subject" do
      expect(mail.subject).to_not be_nil
    end

    it "renders the receiver" do
      expect(mail.to).to eq([crafter.email])
    end

    it "renders the send" do
      expect(mail.from).to eq(['noreply@abcinc.com'])
    end

    it "bcc's the footprints team" do
      expect(mail.bcc).to eq([ENV["FOOTPRINTS_TEAM"]])
    end
  end
end
