require 'spec_helper'

describe Applicant do
  let(:today) { Date.today }
  let(:yesterday) { Date.yesterday }
  let(:tomorrow) { Date.tomorrow }
  let(:attrs) do
    {
      :name => "Leslie Carns",
      :email => "leslie@test.com",
      :applied_on => yesterday,
      :discipline => "developer",
      :skill => "resident",
      :location => "Chicago"
    }
  end

  let(:message)    { Message.new(:title => "Title", :body => "Body", :created_at => Date.today) }
  let!(:crafter) { Crafter.create(:name => "A Crafter", :email => "acrafter@abcinc.com", :employment_id => "1234") }

  it "has available code schools" do
    Applicant.code_schools.should_not be_empty
  end

  context "validation" do
    let(:applicant) { Footprints::Repository.applicant.create(attrs) }

    after :each do
      Crafter.destroy_all
    end

    it "requires a name, applied on date, and valid email" do
      applicant.should be_valid
    end

    it "saves assigned crafter if crafter exists" do
      applicant.update_attributes(:assigned_crafter => "A Crafter", :crafter_id => crafter.id)
      applicant.crafter_id.should == crafter.id
    end

    it "does not save assigned crafter if crafter does not exist" do
      applicant.update(:assigned_crafter => "Some Crafter")
      applicant.should_not be_valid
    end

    it "does not set hired if no decision_made_on date" do
      applicant.update(:hired => "yes", :assigned_crafter => "A Crafter")
      expect(applicant).not_to be_valid
    end

    it "allows decision_made_on to be set with hiring decision" do
      applicant.update(:decision_made_on => DateTime.current,
                       :start_date => Date.today,
                       :end_date => Date.tomorrow,
                       :hired => "yes",
                       :mentor => "A Crafter")
      expect(applicant).to be_valid
    end

    it "does not allow hired to be set to invalid value" do
      applicant.update(:decision_made_on => DateTime.current, :hired => "banana", :assigned_crafter => "A Crafter")
      expect(applicant).not_to be_valid
    end

    it "must have assigned crafter with hiring decision" do
      applicant.update(:decision_made_on => DateTime.current, :hired => "yes")
      expect(applicant).not_to be_valid
    end

    it "must have a mentor for a hiring decision to be made" do
      applicant.update(:decision_made_on => DateTime.current, :hired => "yes", :assigned_crafter => "A Crafter")
      expect(applicant).to have(1).error_on(:mentor)
    end

    it "does not save mentor if mentor does not exist" do
      applicant.update(:mentor => "Unknown Crafter")
      expect(applicant).to have(1).error_on(:mentor)
    end

    it "requires the start date to come before the end date" do
      applicant.update(assigned_crafter: "A Crafter", :decision_made_on => Date.yesterday, :hired => "yes", :start_date => DateTime.current, :end_date => DateTime.yesterday )
      expect(applicant).not_to be_valid
    end

    it "requires start and end date when decision is made on a applicant" do
      applicant.update(:assigned_crafter => "A Crafter", :decision_made_on => Date.yesterday, :hired => "yes")
      expect(applicant).to have(1).error_on(:start_date)
      expect(applicant).to have(1).error_on(:end_date)
    end
 end

  context "outstanding" do
    before :all do
      Crafter.create(:name => "Tywin Lannister", :email => "tywin@sevenkingdoms.com", :employment_id => 1)
    end

    before :each do
      attrs[:applied_on] = 3.days.ago
      attrs[:assigned_crafter] = "Tywin Lannister"
    end

    it "recognizes outstanding request without replies" do
      applicant = Applicant.create(attrs)
      Notification.create(:applicant => applicant, :crafter_id => applicant.crafter.id, :created_at => 1.day.ago)
      expect(applicant.outstanding?(1)).to be_true
    end

    it "request is not outstanding if there has been a reply" do
      attrs[:has_steward] = true
      applicant = Applicant.create(attrs)
      Notification.create(:applicant => applicant, :crafter_id => applicant.crafter.id, :created_at => 1.day.ago)
      expect(applicant.outstanding?(1)).to be_false
    end
  end

  describe "applicant attributes" do
    before(:each) do
      @applicant = Applicant.new(attrs)
      @applicant.save!
    end

    it "has applicants name" do
      @applicant.name.should == "Leslie Carns"
    end

    it "has an applicants email" do
      @applicant.email.should == "leslie@test.com"
    end

    it "requires a valid email" do
      meagan = Applicant.create(:name => "Leslie Carns", :email => "meagan@", :applied_on => yesterday,
                                :discipline => "developer", :skill => "resident", :location => "Chicago")
      meagan.should_not be_valid
    end

    it "requires unique email" do
      meagan = Applicant.create(:name => "Leslie Carns", :email => "leslie@test.com", :applied_on => yesterday,
                                :discipline => "developer", :skill => "resident", :location => "Chicago")
      meagan.should_not be_valid
    end

    it "does not create an applicant with an invalid code_submission" do
      applicant = Applicant.create(name: "Foo", email: "foo@bar.com", applied_on: Date.today, code_submission: "bad url",
                                   :discipline => "developer", :skill => "resident", :location => "Chicago")
      applicant.should_not be_valid
    end

    it "does not create an applicant with a non-string code_submission" do
      applicant = Applicant.create(name: "Foo", email: "foo@bar.com", applied_on: Date.today, code_submission: "10",
                                   :discipline => "developer", :skill => "resident", :location => "Chicago")
      applicant.should_not be_valid
    end

    it "creates an applicant with a valid code_submission" do
      applicant = Applicant.create(name: "Foo", email: "foo@bar.com", applied_on: Date.today, code_submission: "http://www.google.com",
                                   :discipline => "developer", :skill => "resident", :location => "Chicago")
      applicant.should be_valid
    end

    it "does not create an applicant with an invalid code_submission" do
      applicant = Applicant.create(name: "Foo", email: "foo@bar.com", applied_on: Date.today, code_submission: "invalid_link",
                                   :discipline => "developer", :skill => "resident", :location => "Chicago")
      applicant.should_not be_valid
    end

    it "creates an applicant with a valid code_submission" do
      applicant = Applicant.create(name: "Foo", email: "foo@bar.com", applied_on: Date.today, code_submission: "http://www.google.com",
                                   :discipline => "developer", :skill => "resident", :location => "Chicago")
      applicant.should be_valid
    end

    it "does not create an applicant with non-string code_submission" do
      applicant = Applicant.create(name: "Foo", email: "foo@bar.com", applied_on: Date.today, code_submission: 33,
                                   :discipline => "developer", :skill => "resident", :location => "Chicago")
      applicant.should_not be_valid
    end

    it "requires a name" do
      Applicant.create(:email => "test@test.com", :discipline => "developer", :skill => "resident", :location => "Chicago").should_not be_valid
    end

    it "requires an applied_on date" do
      Applicant.create(:name => "Foo bar", :email => "Foo@bar.com", :discipline => "developer", :skill => "resident", :location => "Chicago").should_not be_valid
    end

    it "requires dates be valid" do
      @applicant.update(:completed_challenge_on => tomorrow + 1)
      @applicant.save.should be_false
    end

    it "no dates can be future dates" do
      @applicant.update(:completed_challenge_on => today + 5)
      @applicant.save.should be_false
    end

    it "has messages" do
      message.applicant_id = @applicant.id
      @applicant.messages.should == []
    end

    it "sets archived to true after decision has been made" do
      expect(@applicant.decision_made_on).to be_false
      expect(@applicant.archived).to be_false
      @applicant.update_attribute(:decision_made_on, DateTime.current)
      expect(@applicant.archived).to be_true
    end
  end
end
