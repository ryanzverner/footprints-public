require 'spec_helper'
require './lib/applicants/applicant_interactor.rb'

describe ApplicantInteractor do
  let!(:crafter) { Footprints::Repository.crafter.create(:name => "A Crafter", :employment_id => "007", :email => "acrafter@example.com") }
  let!(:bcrafter) { Footprints::Repository.crafter.create(:name => "B Crafter", :employment_id => "008", :email => "bcrafter@example.com") }
  let!(:applicant) { Footprints::Repository.applicant.create(:name => "Bob", :applied_on => Date.current, :email => "test@test.com", :location => "Chicago",
                                                             :skill => "student", :discipline => "sofware") }

  describe "#update" do
    it "updates the applicant" do
      params = { :name => "John" }
      ApplicantInteractor.new(applicant, params).update
      expect(applicant.name).to eq("John")
    end
  end

  describe "#update_applicant_for_hiring" do
    before :each do
      params = { mentor: "A Crafter", start_date: Date.today, end_date: Date.today + 10 }
      ApplicantInteractor.new(applicant, params).update_applicant_for_hiring
    end

    it "updates the applicant's decision_on date" do
      expect(applicant.decision_made_on).to eq(Date.today)
    end

    it "updates the applicant's decision_on date" do
      expect(applicant.hired).to eq("yes")
    end
  end

  describe "#crafter_changed?" do
    context "crafter has changed" do
      it "recognizes that assigned crafter has changed" do
        applicant.assigned_crafter = "B Crafter"
        interactor = ApplicantInteractor.new(applicant, :assigned_crafter => "A Crafter")
        expect(interactor.crafter_changed?).to be_true
      end
    end

    context "crafter has not changed" do
      it "returns false if crafter changes from nil to empty string" do
        expect(applicant.assigned_crafter).to be_nil
        interactor = ApplicantInteractor.new(applicant, :assigned_crafter => "")
        expect(interactor.crafter_changed?).to be_false
      end

      it "returns false if crafter has not changed" do
        applicant.update_attribute(:assigned_crafter, "A Crafter")
        interactor = ApplicantInteractor.new(applicant, :assigned_crafter => "A Crafter")
        applicant.assigned_crafter = "A Crafter"
        expect(interactor.crafter_changed?).to be_false
      end
    end
  end

  describe "#notify_if_crafter_changed" do
    context "initial crafter assigned" do
      it "calls send_request_email" do
        applicant.assigned_crafter = "A Crafter"
        interactor = ApplicantInteractor.new(applicant, {})
        allow(interactor).to receive(:send_request_email)
        allow(interactor).to receive(:send_transfer_email)
        interactor.notify_if_crafter_changed
        expect(interactor).to have_received(:send_request_email)
        expect(interactor).to_not have_received(:send_transfer_email)
      end
    end

    context "crafter has not changed" do
      it "doesn't call send request email" do
        params = {:assigned_crafter => applicant.assigned_crafter}
        interactor = ApplicantInteractor.new(applicant, params)
        interactor.notify_if_crafter_changed
        expect(interactor).to_not receive(:send_request_email)
      end
    end

    context "applicant transfered to another crafter" do
      it "calls send_transfer_email" do
        applicant.update_attributes(:assigned_crafter => "A Crafter", :has_steward => true)
        applicant.assigned_crafter = "B Crafter"
        params = { :assigned_crafter => "B Crafter"}
        interactor = ApplicantInteractor.new(applicant, params)
        allow(interactor).to receive(:send_transfer_emails)
        interactor.notify_if_crafter_changed
        expect(interactor).to have_received(:send_transfer_emails)
      end

      it "sends transfer email to correct crafter" do
        ActionMailer::Base.deliveries = []
        applicant.update_attributes(:assigned_crafter => "A Crafter", :has_steward => true)
        params = { :assigned_crafter => "B Crafter"}
        interactor = ApplicantInteractor.new(applicant, params)
        interactor.update
        mail = ActionMailer::Base.deliveries
        expect(mail.count).to eq(2)
        expect(mail.first.to).to eq(["acrafter@example.com"])
        expect(mail.last.to).to eq(["bcrafter@example.com"])
      end

    end

    context "applicant has not been transfered" do
      it "doesn't call send_transfer_email" do
        params = {:assigned_crafter => applicant.assigned_crafter}
        interactor = ApplicantInteractor.new(applicant, params)
        allow(interactor).to receive(:send_transfer_email)
        interactor.notify_if_crafter_changed
        expect(interactor).to_not have_received(:send_transfer_email)
      end
    end

    context "invalid update information" do
      it "doesn't send email to crafter if update invalid" do
        params = {:name => "", :assigned_crafter => "A Crafter"}
        interactor = ApplicantInteractor.new(applicant, params)
        allow(interactor).to receive(:send_request_email)
        applicant.assign_attributes(params)
        expect { interactor.update }.to raise_error ActiveRecord::RecordInvalid
        expect(interactor).not_to have_received(:send_request_email)
      end
    end

    context "archiving an applicant" do
      it "archives an applicant if the checkbox is selected" do
        params = {:archived => "on"}
        interactor = ApplicantInteractor.new(applicant, params)
        allow(interactor).to receive(:send_request_email)
        interactor.update
        expect(applicant.reload.archived).to be_true
      end

      it "unarchives an applicant if the checkbox is empty" do
        params = {:archived => "off"}
        interactor = ApplicantInteractor.new(applicant, params)
        allow(interactor).to receive(:send_request_email)
        interactor.update
        expect(applicant.reload.archived).to be_false
      end
    end
  end

  describe "#notify_if_decision_made" do
    let!(:applicant) { Footprints::Repository.applicant.create(:name => "Bill", :applied_on => Date.current,
                                                               :email => "test@example.com", :crafter_id => crafter.id,
                                                               :assigned_crafter => "A Crafter", :has_steward => true,
                                                               :discipline => "developer", :skill => "resident", :location => "Chicago") }

    before :each do
      ActionMailer::Base.deliveries = []
      allow_any_instance_of(ApplicantInteractor).to receive(:setup_warehouse_api) { double.as_null_object }
    end

    context "applicant hired" do
      it "notifies crafter when an applicant is hired" do
        params = { :decision_made_on => Date.today, :hired => "yes", :start_date => Date.today, :end_date => Date.tomorrow, :mentor => "A Crafter" }
        interactor = ApplicantInteractor.new(applicant, params)
        interactor.update
        mail = ActionMailer::Base.deliveries
        expect(mail.count).to eq(1)
        expect(mail.first.subject).to eq "[Footprints] A decision has been made on applicant #{applicant.name}"
        expect(mail.first.to).to include ENV["ADMIN_EMAIL"]
      end

      it "doesn't notify crafter if hired was not set on current update" do
        applicant.update_attributes(:decision_made_on => Date.today, :hired => "yes", :start_date => Date.today, :end_date => Date.tomorrow, :mentor => "A Crafter")
        ActionMailer::Base.deliveries = []
        interactor = ApplicantInteractor.new(applicant, {})
        interactor.update
        mail = ActionMailer::Base.deliveries
        expect(mail).to be_empty
      end
    end

    context "applicant not hired" do
      it "doesn't notify crafter if decision has not been made" do
        interactor = ApplicantInteractor.new(applicant, {})
        interactor.update
        mail = ActionMailer::Base.deliveries
        expect(mail).to be_empty
      end

      it "doesn't notify crafter if applicant was not hired" do
        params = { :decision_made_on => DateTime.current, :hired => "no" }
        interactor = ApplicantInteractor.new(applicant, params)
        interactor.update
        mail = ActionMailer::Base.deliveries
        expect(mail).to be_empty
      end
    end
  end

  describe "#send_to_warehouse_if_hired" do

    let!(:applicant) { 
      Footprints::Repository.applicant.create(
        :name => "Bill", 
        :applied_on => Date.current, 
        :email => "test@example.com",
        :crafter_id => crafter.id, 
        :assigned_crafter => "A Crafter",
        :has_steward => true, 
        :discipline => "developer", 
        :skill => "student",
        :location => "Chicago") }

    it "sends apprentices to warehouse if they are hired" do
      applicant.assign_attributes(:decision_made_on => Date.today,
                                  :hired => "yes",
                                  :start_date => Date.today,
                                  :end_date => Date.tomorrow,
                                  :mentor => "A Crafter",
                                  :skill => "resident")
      api = double("warehouse_api").as_null_object
      allow_any_instance_of(ApplicantInteractor).to receive(:setup_warehouse_api) { api }
      interactor = ApplicantInteractor.new(applicant, {})
      interactor.update
      expect(api).to have_received(:add_resident!)
    end

    it "sends student apprentices to warehouse if they are hired" do
      applicant.assign_attributes(:decision_made_on => Date.today,
                                  :hired => "yes",
                                  :start_date => Date.today,
                                  :end_date => Date.tomorrow,
                                  :mentor => "A Crafter",
                                  :skill => "student")
      api = double("warehouse_api").as_null_object
      allow_any_instance_of(ApplicantInteractor).to receive(:setup_warehouse_api) { api }
      interactor = ApplicantInteractor.new(applicant, {})
      interactor.update
      expect(api).to have_received(:add_student!)
    end
  end
end
