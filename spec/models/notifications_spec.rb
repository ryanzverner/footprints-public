require 'spec_helper'
require 'spec_helpers/applicant_factory'
require 'spec_helpers/crafter_factory'
require 'ar_repository/models/notification'

describe Notification do
  applicant_factory = SpecHelpers::ApplicantFactory.new
  crafter_factory = SpecHelpers::CrafterFactory.new

  it "creates notification for applicant and crafter" do
    crafter = crafter_factory.create
    applicant = applicant_factory.create
    notification = Notification.create(:applicant_id => applicant.id,
                                       :crafter_id => crafter.id)
    expect(notification.crafter).to eq crafter
    expect(notification.applicant).to eq applicant
  end
end
