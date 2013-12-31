require 'applicant_dispatch/strategies/filter_strategy'

describe "ApplicantDispatch::Filters::PreviouslyDeniedFilter" do
  subject { ApplicantDispatch::Filters::PreviouslyDeniedFilter }

  let(:applicant) { double(:applicant) }
  let(:craftsman) { double(:craftsman) }

  it "removes craftsmen that have previously denied the applicant" do
    allow(craftsman).to receive(:previously_denied_applicant?).with(applicant) { true }

    updated_craftsmen_list = subject.call([craftsman], applicant)

    expect(updated_craftsmen_list).to eq([])
  end

  it "does not zero out the score if a craftsman has not previously denied the applicant" do
    allow(craftsman).to receive(:previously_denied_applicant?).with(applicant) { false }

    updated_craftsmen_list = subject.call([craftsman], applicant)

    expect(updated_craftsmen_list).to eq([craftsman])
  end
end
