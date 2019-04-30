require 'spec_helper'
require './lib/dashboard/dashboard_interactor'

describe DashboardInteractor do
  let(:repo) { Footprints::Repository }

  let(:confirmed_applicant)          { repo.applicant.create(name: "Confirmeded App", applied_on: Date.today, email: "test1@test.com",
                                                             assigned_crafter: "A. Crafter", crafter_id: crafter.id, has_steward: true,
                                                             discipline: "developer", skill: "resident", location: "Chicago") }
  let(:unconfirmed_applicant_one)    { repo.applicant.create(name: "Applicant One", applied_on: Date.today, email: "test2@test.com",
                                                             assigned_crafter: "A. Crafter", crafter_id: crafter.id, has_steward: false,
                                                             discipline: "developer", skill: "resident", location: "Chicago") }
  let(:unconfirmed_applicant_two)    { repo.applicant.create(name: "Applicant Two", applied_on: Date.today, email: "test3@test.com",
                                                             assigned_crafter: "A. Crafter", crafter_id: crafter.id, has_steward: false,
                                                             discipline: "developer", skill: "resident", location: "London") }
  let(:crafter)                    { repo.crafter.create(name: "A. Crafter", employment_id: '123', email: 'testcrafter@abcinc.com') }
  let(:crafter_without_applicants) { repo.crafter.create(name: "B. Crafter", employment_id: '567', email: 'testcrafter2@abcinc.com') }
  let(:interactor)                   { DashboardInteractor.new(repo.crafter) }

  before :each do
    repo.assigned_crafter_record.create({applicant_id: unconfirmed_applicant_one.id, crafter_id: crafter.id})
    repo.assigned_crafter_record.create({applicant_id: unconfirmed_applicant_two.id, crafter_id: crafter.id})
    repo.assigned_crafter_record.create({applicant_id: confirmed_applicant.id, crafter_id: crafter.id})
  end

  context '#confirmed_applicants' do
    it 'returns the confirmed applicants' do
      expect(interactor.confirmed_applicants(crafter).first).to eq confirmed_applicant
    end
  end

  context '#not_yet_responded_applicants' do
    it 'returns the applicants that are waiting for response' do
      expect(interactor.not_yet_responded_applicants(crafter).count).to eq 2
    end
  end

  context '#assign_steward_for_applicant' do
    it 'assigns the steward for an applicant' do
      interactor.assign_steward_for_applicant(unconfirmed_applicant_one)

      expect(unconfirmed_applicant_one.has_steward).to eq true
    end
  end

  context '#decline_applicant' do
    it 'declines an unconfirmed applicant' do
      interactor.decline_applicant(unconfirmed_applicant_one)

      expect(unconfirmed_applicant_one.assigned_crafter).to eq nil
    end
  end

  context '#decline_all_applicants' do
    it 'declines all unconfirmed applicants' do
      interactor.decline_all_applicants(crafter)

      expect(interactor.assigned_applicants(crafter)).to eq []
    end

    it 'dispatches all applicants to new crafters after decline' do
      expect(interactor).to receive(:assign_new_crafter).with(unconfirmed_applicant_one)
      expect(interactor).to receive(:assign_new_crafter).with(unconfirmed_applicant_two)

      interactor.decline_all_applicants(crafter)
    end

    it "sets the date until which the crafter is unavailable for new applicants" do
      interactor.has_applicants?(crafter)
      interactor.update_crafter_availability_date(crafter, Date.today + 1)

      expect(crafter.unavailable_until).to eq(Date.today + 1)
    end

    it "does not set the Crasftman's unavailability if there are no applicants to decline" do
      interactor.update_crafter_availability_date(crafter, Date.today + 1)

      expect(crafter_without_applicants.unavailable_until).to eq nil
    end
  end

  context '#decline_all_applicants_and_set_availability_date' do
    before(:each) do
      interactor.decline_all_applicants_and_set_availability_date(crafter, Date.today + 1)
    end

    it 'sets the date' do
      expect(crafter.unavailable_until).to eq(Date.today + 1)
    end

    it 'declines all applicants' do
      expect(interactor.assigned_applicants(crafter)).to eq []
    end
  end
end
