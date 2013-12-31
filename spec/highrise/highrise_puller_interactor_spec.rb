require 'spec_helper'
require 'highrise/highrise_puller_interactor'

describe Interactor::HighrisePuller do
  let(:repo) { Footprints::Repository }
  let(:application) { double("application", :body => "By:          Applicant\nEmail:       test@test.com\nPublication: http://www.google.com\n\n----\nQ: what's your story?\nA: \"story\"\n\n----\nQ: what do you love about writing software?\nA: \"software\"\n\n----\nQ: why do you want to be a(n) craftsman at ABC, Inc.?\nA: \"craftsman\"\n", :subject_name => "Applicant", :created_at => Time.current, :location => "Chicago") }
  before(:each) do
    allow(Highrise::Recording).to receive(:find_all_across_pages_since) { [application] }
  end

  it "parses the email properly" do
    allow(repo.applicant).to receive(:create)
    puller = described_class.new
    puller.create_applicants([application])
    data = {
      :name              => "Applicant",
      :applied_on        => Date.current,
      :email             => "test@test.com",
      :url               => "http://www.google.com",
      :about             => "story",
      :software_interest => "software",
      :reason            => "craftsman",
      :discipline        => "software",
      :location          => "Chicago",
      :skill             => "craftsman"
    }
    expect(repo.applicant).to have_received(:create).with(data)
    expect(repo.applicant.new(data)).to be_valid
  end
end
