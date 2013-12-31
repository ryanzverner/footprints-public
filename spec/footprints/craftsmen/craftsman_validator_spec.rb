require 'spec_helper'
require './app/validators/craftsman_validator'

describe CraftsmanValidator do
  let(:applicant) { Footprints::Repository.applicant.create(:name => "A Applicant", :applied_on => Date.current,
                                                            :discipline => "developer", :skill => "resident", :location => "Chicago") }

  context "valid" do
    it "validates applicant with valid craftsman" do
      craftsman = Footprints::Repository.craftsman.create(:name => "A Craftsman", :employment_id => "007")
      applicant.assigned_craftsman = "A Craftsman"
      expect(applicant).to be_valid
    end

    it "allows applicant to be valid when assigned craftsman is empty string" do
      applicant.assigned_craftsman = ""
      expect(applicant).to be_valid
    end
  end

  context "invalid" do
    it "invalidates applicant with invalid craftsman" do
      applicant.assigned_craftsman = "Invalid Craftsman"
      expect(applicant).not_to be_valid
    end

    it "invalidates attempt to un-assign craftsman who has already accepted" do
      applicant.update_attributes(:assigned_craftsman => "A Craftsman", :has_steward => true)
      applicant.assigned_craftsman = ""
      expect(applicant).not_to be_valid
    end
  end
end
