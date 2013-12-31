require 'spec_helper'

describe AnalyticsHelper do
  let(:repo) { Footprints::Repository }

  before :each do
    repo.applicant.destroy_all
    repo.craftsman.destroy_all
    craftsman = repo.craftsman.create(:name => "A Craftsman", :email => "acraftsman@abcinc.com", :employment_id => "7")
    @applicant = repo.applicant.create(name: "Alice", email: "alice@bar.com", applied_on: Date.parse('20130115'), initial_reply_on: Date.parse('20130117'), codeschool: "Starter League",
                                      :discipline => "developer", :skill => "resident", :location => "Chicago")
    repo.applicant.create(name: "Bob", email: "bob@bar.com", applied_on: Date.parse('20130115'), initial_reply_on: Date.parse('20130117'),
                          :sent_challenge_on => Date.parse('20130201'), completed_challenge_on: Date.parse('20130201'), codeschool: "Starter League", :location => "Chicago",
                          :discipline => "developer", :skill => "resident")
    repo.applicant.create(name: "Carl", email: "carl@bar.com", applied_on: Date.parse('20130115'), initial_reply_on: Date.parse('20130117'),
                          :sent_challenge_on => Date.parse('20130201'), completed_challenge_on: Date.parse('20130201'), reviewed_on: Date.parse('20130210'), codeschool: "Starter League",
                          :location => "Chicago", :discipline => "developer", :skill => "resident")
    repo.applicant.create(name: "Daphne", email: "daphne@bar.com", applied_on: Date.parse('20130115'), initial_reply_on: Date.parse('20130117'),
                          :sent_challenge_on => Date.parse('20130201'), completed_challenge_on: Date.parse('20130201'), reviewed_on: Date.parse('20130210'),
                          resubmitted_challenge_on: Date.parse('20130220'), :location => "Chicago", :discipline => "developer", :skill => "resident")
    repo.applicant.create(name: "Emily", email: "emily@bar.com", applied_on: Date.parse('20130115'), initial_reply_on: Date.parse('20130117'), :sent_challenge_on => Date.parse('20130201'),
                          completed_challenge_on: Date.parse('20130201'), reviewed_on: Date.parse('20130210'), resubmitted_challenge_on: Date.parse('20130220'),
                          decision_made_on: Date.parse('20130302'), :hired => "no", :assigned_craftsman => "A Craftsman", :location => "Chicago", :discipline => "developer", :skill => "resident")
    repo.applicant.create(name: "Zeb", email: "zeb@bar.com", applied_on: Date.parse('20130115'), initial_reply_on: Date.parse('20130117'), :sent_challenge_on => Date.parse('20130201'),
                          completed_challenge_on: Date.parse('20130201'), reviewed_on: Date.parse('20130210'), :location => "Chicago", :discipline => "developer", :skill => "resident")
  end

  describe "#average_lapse_time" do
    it "returns correct value for applied -> decision made" do
      average_lapse_time('decision_made_on', 'applied_on').should == "46 days"
    end

    it "returns correct value for applied -> initial reply" do
      average_lapse_time('initial_reply_on', 'applied_on').should == "2 days"
    end

    it "returns correct value for initial -> complete challenge" do
      average_lapse_time('completed_challenge_on', 'initial_reply_on').should == "15 days"
    end

    it "returns correct value for completed -> reviewed" do
      average_lapse_time('reviewed_on', 'completed_challenge_on').should == '9 days'
    end

    it "returns correct value for reviewed -> resubmitted" do
      average_lapse_time('resubmitted_challenge_on', 'reviewed_on').should == '10 days'
    end

    it "returns correct value for reviewed -> resubmitted" do
      average_lapse_time('decision_made_on', 'resubmitted_challenge_on').should == '10 days'
    end

    it "returns not enough data message" do
      repo.applicant.destroy_all
      average_lapse_time('decision_made_on', 'resubmitted_challenge_on').should == 'Not enough data'
    end
  end

  describe "#fall_off" do
    it 'returns correct percentage after initial reply' do
      fall_off('initial_reply_on', 60).should == "17%"
    end

    it 'returns correct percentage after review' do
      fall_off('reviewed_on', 60).should == '50%'
    end
  end

  describe "#get_background_percentage" do
    it 'returns the correct percentage' do
      get_background_percentage("codeschool", "Starter League").should == "50.0%"
    end
  end

  describe "#get_background_count" do
    it 'returns the correct count' do
      get_background_count("codeschool", "Starter League").should == 3
    end
  end

  describe "#display_background_info" do
    it 'displays the correct count and percentage' do
      display_background_info("codeschool", "Starter League").should == "50.0% / 3 applicants"
    end
  end
end
