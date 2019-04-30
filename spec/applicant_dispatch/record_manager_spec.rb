require 'spec_helper'
require 'applicant_dispatch/record_manager'
require 'spec_helpers/applicant_factory'
require 'spec_helpers/crafter_factory'

describe ApplicantDispatch::RecordManager do
  applicant_factory = SpecHelpers::ApplicantFactory.new
  crafter_factory = SpecHelpers::CrafterFactory.new

  let(:applicant) { applicant_factory.create }
  let(:crafter) { crafter_factory.create }

  it "sets assigned_crafter_records#current to false after 10 days" do
    AssignedCrafterRecord.create(:applicant_id => applicant.id, :crafter_id => crafter.id, :created_at => 10.days.ago)
    current_records = AssignedCrafterRecord.where(:applicant_id => applicant.id,
                                                    :crafter_id => crafter.id,
                                                    :current => true)
    expect(current_records.count).to eq(1)
    described_class.new.expire_assigned_crafter_records
    expect(current_records.count).to eq(0)
  end

  it "doesn't set assigned_crafter_records#current to false before 10 days" do
    AssignedCrafterRecord.create(:applicant_id => applicant.id, :crafter_id => crafter.id, :created_at => 9.days.ago)
    current_records = AssignedCrafterRecord.where(:applicant_id => applicant.id,
                                                    :crafter_id => crafter.id,
                                                    :current => true)
    expect(current_records.count).to eq(1)
    described_class.new.expire_assigned_crafter_records
    expect(current_records.count).to eq(1)
  end
end
