require 'applicant_dispatch/dispatcher'
require 'spec_helpers/applicant_factory'
require 'spec_helpers/craftsman_factory'
require 'craftsmen/skills'

describe ApplicantDispatch::Dispatcher do
  applicant_factory = SpecHelpers::ApplicantFactory.new
  craftsman_factory = SpecHelpers::CraftsmanFactory.new

  let(:resident_skill) { Skills.get_key_for_skill('Resident') }

  let!(:steward) { 
    craftsman_factory.create(:name => "Steward Sterlington", 
                             :email => "johndoe@example.com", 
                             :employment_id => 777)
  }

  let!(:applicant) {
    applicant_factory.create(skill: resident_skill,
                             discipline: "developer",
                             location: "Chicago")
  }

  let!(:craftsman) {
    craftsman_factory.create(seeking: true, 
                             skill: resident_skill, 
                             location: "Chicago", 
                             position: "Software Craftsman")
  }

  it "assigns an applicant to the best available craftsman" do
    described_class.new(applicant, steward).assign_applicant

    expect(applicant.reload.craftsman).to eq(craftsman)
  end

  it "defaults applicants to the steward when unassignable" do
    craftsman.update_attributes(:location => "London")

    described_class.new(applicant, steward).assign_applicant

    expect(applicant.reload.craftsman).to eq(steward)
  end

  it "defaults applicants to the steward even if location is blank" do
    applicant.update_attributes(:location => "")

    described_class.new(applicant, steward).assign_applicant

    expect(applicant.reload.craftsman).to eq(steward)
  end

  it "creates assigned craftsman record when assigning applicant" do
    expect(applicant.assigned_craftsman_records.count).to eq(0)

    described_class.new(applicant, steward).assign_applicant

    expect(applicant.assigned_craftsman_records.count).to eq(1)
  end

  it "notifies craftsman when dispatcher assigns an applicant" do
    deliveries = ActionMailer::Base.deliveries = []

    described_class.new(applicant, steward).assign_applicant

    expect(deliveries.count).to eq(1)
    expect(deliveries.first.to).to eq([applicant.craftsman.email])
  end

  it "sends the Footprints team a message if an error occurs while assigning" do
    Footprints::Repository.craftsman.destroy_all

    described_class.new(applicant, steward).assign_applicant

    expect(ActionMailer::Base.deliveries.last.to).to eq([ENV['FOOTPRINTS_TEAM']])
  end
end
