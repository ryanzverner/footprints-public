require './lib/reminder/reminder.rb'
require 'spec_helper'
require 'spec_helpers/applicant_factory'
require 'spec_helpers/crafter_factory'

describe Footprints::Reminder do
  let(:applicant_factory) { SpecHelpers::ApplicantFactory.new }
  let(:crafter_factory) { SpecHelpers::CrafterFactory.new }
  let!(:steward) { Crafter.create(:name => "Test Steward", :email => ENV["STEWARD"], :employment_id => 777) }


  before :all do
    Crafter.create(:name => "A. Crafter", :email => "acrafter@abcinc.com", :employment_id => "1234")
  end

  before :each do
    ActionMailer::Base.deliveries = []
  end

  it "reminds crafter when the applicant is outstanding 1 day" do
    applicant = Applicant.create(:name => "A. Applicant", :assigned_crafter => "A. Crafter", :applied_on => 1.day.ago, :created_at => 1.day.ago, :discipline => "developer", :skill => "resident", :location => "Chicago")
    notifications = Notification.where(:applicant => applicant, :crafter => applicant.crafter)
    expect(notifications.count).to eq(0)
    described_class.notify_crafter_of_outstanding_requests
    expect(notifications.reload.count).to eq(1)
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it "doesn't remind crafter if applicant is not outstanding" do
    applicant = Applicant.create(:name => "A. Applicant", :assigned_crafter => "A. Crafter", :applied_on => Date.today, :discipline => "developer", :skill => "resident", :location => "Chicago")
    notifications = Notification.where(:applicant => applicant, :crafter => applicant.crafter)
    expect(notifications.count).to eq(0)
    described_class.notify_crafter_of_outstanding_requests
    expect(notifications.reload.count).to eq(0)
  end

  it "reminds steward when the applicant is outstanding 3 days" do
    applicant = Applicant.create(:name => "A. Applicant", :assigned_crafter => "A. Crafter", :applied_on => 3.days.ago, :discipline => "developer", :skill => "resident", :location => "Chicago")
    notifications = Notification.where(:applicant => applicant, :crafter => steward)
    expect(notifications.count).to eq(0)
    Notification.create(:applicant => applicant, :crafter => applicant.crafter,
                        :created_at => 2.days.ago)
    described_class.notify_crafter_of_outstanding_requests
    expect(notifications.reload.count).to eq(1)
  end

  it "doesn't remind steward if applicant is not outstanding" do
    applicant = Applicant.create(:name => "A. Applicant", :assigned_crafter => "A. Crafter", :applied_on => 7.days.ago, :discipline => "developer", :skill => "resident", :location => "Chicago")
    described_class.notify_crafter_of_outstanding_requests
    notifications = Notification.where(:applicant => applicant, :crafter => steward)
    expect(notifications.count).to eq(0)
  end

  it "only reminds steward once" do
    applicant = applicant_factory.create(:created_at => 3.days.ago, :assigned_crafter => "A. Crafter", :has_steward => false)
    notification = Notification.create(:applicant => applicant, :crafter => steward)
    expect(steward.notifications.count).to eq(1)
    described_class.notify_crafter_of_outstanding_requests
    expect(steward.notifications.count).to eq(1)
  end

end
