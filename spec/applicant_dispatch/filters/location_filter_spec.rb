require 'applicant_dispatch/strategies/filter_strategy'

describe "ApplicantDispatch::Filters::LocationFilter" do
  subject { ApplicantDispatch::Filters::LocationFilter }

  let(:chicago_craftsman) { double(:location => "Chicago") }
  let(:los_angeles_craftsman) { double(:location => "Los Angeles") }
  let(:london_craftsman)  { double(:location => "London") }
  let(:craftsmen)         { [chicago_craftsman, london_craftsman, los_angeles_craftsman] }

  it "returns Chicago's craftsmen if applicant is applying for Chicago" do
    applicant = double(:location => "Chicago")
    output_craftsmen = subject.call(craftsmen, applicant)

    expect(output_craftsmen).to eq [chicago_craftsman]
  end

  it "returns Los Angeles's craftsmen if applicant is applying for Los Angeles" do
    applicant = double(:location => "Los Angeles")
    output_craftsmen = subject.call(craftsmen, applicant)

    expect(output_craftsmen).to eq [los_angeles_craftsman]
  end

  it "returns London's craftsmen if applicant is applying for London" do
    applicant = double(:location => "london")
    output_craftsmen = subject.call(craftsmen, applicant)

    expect(output_craftsmen).to eq [london_craftsman]
  end
end
