require 'spec_helper'
require 'applicant_dispatch/record_manager'
require 'spec_helpers/applicant_factory'
require 'spec_helpers/craftsman_factory'

describe ApplicantDispatch::RecordManager do
  applicant_factory = SpecHelpers::ApplicantFactory.new
  craftsman_factory = SpecHelpers::CraftsmanFactory.new

  let(:applicant) { applicant_factory.create }
  let(:craftsman) { craftsman_factory.create }

  it "sets assigned_craftsman_records#current to false after 10 days" do
    AssignedCraftsmanRecord.create(:applicant_id => applicant.id, :craftsman_id => craftsman.id, :created_at => 10.days.ago)
    current_records = AssignedCraftsmanRecord.where(:applicant_id => applicant.id,
                                                    :craftsman_id => craftsman.id,
                                                    :current => true)
    expect(current_records.count).to eq(1)
    described_class.new.expire_assigned_craftsman_records
    expect(current_records.count).to eq(0)
  end

  it "doesn't set assigned_craftsman_records#current to false before 10 days" do
    AssignedCraftsmanRecord.create(:applicant_id => applicant.id, :craftsman_id => craftsman.id, :created_at => 9.days.ago)
    current_records = AssignedCraftsmanRecord.where(:applicant_id => applicant.id,
                                                    :craftsman_id => craftsman.id,
                                                    :current => true)
    expect(current_records.count).to eq(1)
    described_class.new.expire_assigned_craftsman_records
    expect(current_records.count).to eq(1)
  end
end
