require 'slim_spec_helper'
require 'applicants/applicant_state_machine'
require 'ostruct'

describe ApplicantStateMachine do
  let(:state_machine) { ApplicantStateMachine }

  let(:applied_on_applicant) { OpenStruct.new( :applied_on => Date.today)}

  let(:initial_reply_on_applicant) { OpenStruct.new( :applied_on => Date.today, :initial_reply_on => Date.today )}

  let(:sent_challenge_on_applicant) { OpenStruct.new( :applied_on => Date.today, :initial_reply_on => Date.today,
                                                      :sent_challenge_on => Date.today)}

  let(:completed_challenge_on_applicant) { OpenStruct.new( :applied_on => Date.today, :initial_reply_on => Date.today,
                                                           :sent_challenge_on => Date.today, :completed_challenge_on => Date.today )}

  let(:reviewed_on_applicant) { OpenStruct.new( :applied_on => Date.today, :initial_reply_on => Date.today,
                                                :sent_challenge_on => Date.today, :completed_challenge_on => Date.today,
                                                :reviewed_on => Date.today)}

  let(:offered_on_applicant) { OpenStruct.new(  :applied_on => Date.today, :initial_reply_on => Date.today,
                                                :sent_challenge_on => Date.today, :completed_challenge_on => Date.today,
                                                :reviewed_on => Date.today, :offered_on => Date.today)}

  let!(:decision_made_on_applicant) { OpenStruct.new( :applied_on => Date.today, :initial_reply_on => Date.today, 
                                                      :sent_challenge_on => Date.today, :completed_challenge_on => Date.today,
                                                      :reviewed_on => Date.today, :resubmitted_challenge_on => Date.today,
                                                      :offered_on => Date.today, :decision_made_on => Date.today )}

  it "determines applied_on state" do
    expect(state_machine.determine_state(applied_on_applicant)).to eq "applied_on"
  end

  it "determines initial_reply_on state" do
    expect(state_machine.determine_state(initial_reply_on_applicant)).to eq "initial_reply_on"
  end

  it "determines challenge sent state" do
    expect(state_machine.determine_state(sent_challenge_on_applicant)).to eq "sent_challenge_on"
  end

  it "determines completed_challenge_on state" do
    expect(state_machine.determine_state(completed_challenge_on_applicant)).to eq "completed_challenge_on"
  end

  it "determines reviewed_on state" do
    expect(state_machine.determine_state(reviewed_on_applicant)).to eq "reviewed_on"
  end

  it "determines offered_on state" do
    expect(state_machine.determine_state(offered_on_applicant)).to eq "offered_on"
  end

  it "determines decision_made_on state" do
    expect(state_machine.determine_state(decision_made_on_applicant)).to eq "decision_made_on"
  end

  context "applicants with skipped states" do
    let(:skipped_initial_reply) { OpenStruct.new( :applied_on => Date.today, :sent_challenge_on => Date.today) }

    it "determines challenge_sent state" do
      expect(state_machine.determine_state(skipped_initial_reply)).to eq "sent_challenge_on"
    end
  end
end
