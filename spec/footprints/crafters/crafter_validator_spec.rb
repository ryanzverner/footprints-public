require 'spec_helper'
require './app/validators/crafter_validator'

describe CrafterValidator do
  let(:applicant) { Footprints::Repository.applicant.create(:name => "A Applicant", :applied_on => Date.current,
                                                            :discipline => "developer", :skill => "resident", :location => "Chicago") }

  context "valid" do
    it "validates applicant with valid crafter" do
      crafter = Footprints::Repository.crafter.create(:name => "A Crafter", :employment_id => "007")
      applicant.assigned_crafter = "A Crafter"
      expect(applicant).to be_valid
    end

    it "allows applicant to be valid when assigned crafter is empty string" do
      applicant.assigned_crafter = ""
      expect(applicant).to be_valid
    end
  end

  context "invalid" do
    it "invalidates applicant with invalid crafter" do
      applicant.assigned_crafter = "Invalid Crafter"
      expect(applicant).not_to be_valid
    end

    it "invalidates attempt to un-assign crafter who has already accepted" do
      applicant.update_attributes(:assigned_crafter => "A Crafter", :has_steward => true)
      applicant.assigned_crafter = ""
      expect(applicant).not_to be_valid
    end
  end
end
