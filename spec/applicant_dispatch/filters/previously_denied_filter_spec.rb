require 'applicant_dispatch/strategies/filter_strategy'

describe "ApplicantDispatch::Filters::PreviouslyDeniedFilter" do
  subject { ApplicantDispatch::Filters::PreviouslyDeniedFilter }

  let(:applicant) { double(:applicant) }
  let(:crafter) { double(:crafter) }

  it "removes crafters that have previously denied the applicant" do
    allow(crafter).to receive(:previously_denied_applicant?).with(applicant) { true }

    updated_crafters_list = subject.call([crafter], applicant)

    expect(updated_crafters_list).to eq([])
  end

  it "does not zero out the score if a crafter has not previously denied the applicant" do
    allow(crafter).to receive(:previously_denied_applicant?).with(applicant) { false }

    updated_crafters_list = subject.call([crafter], applicant)

    expect(updated_crafters_list).to eq([crafter])
  end
end
