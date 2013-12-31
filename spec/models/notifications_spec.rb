require 'spec_helper'
require 'spec_helpers/applicant_factory'
require 'spec_helpers/craftsman_factory'
require 'ar_repository/models/notification'

describe Notification do
  applicant_factory = SpecHelpers::ApplicantFactory.new
  craftsman_factory = SpecHelpers::CraftsmanFactory.new

  it "creates notification for applicant and craftsman" do
    craftsman = craftsman_factory.create
    applicant = applicant_factory.create
    notification = Notification.create(:applicant_id => applicant.id,
                                       :craftsman_id => craftsman.id)
    expect(notification.craftsman).to eq craftsman
    expect(notification.applicant).to eq applicant
  end
end
