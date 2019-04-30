require 'applicant_dispatch/strategies/filter_strategy'

describe "ApplicantDispatch::Filters::LocationFilter" do
  subject { ApplicantDispatch::Filters::LocationFilter }

  let(:chicago_crafter) { double(:location => "Chicago") }
  let(:los_angeles_crafter) { double(:location => "Los Angeles") }
  let(:london_crafter)  { double(:location => "London") }
  let(:crafters)         { [chicago_crafter, london_crafter, los_angeles_crafter] }

  it "returns Chicago's crafters if applicant is applying for Chicago" do
    applicant = double(:location => "Chicago")
    output_crafters = subject.call(crafters, applicant)

    expect(output_crafters).to eq [chicago_crafter]
  end

  it "returns Los Angeles's crafters if applicant is applying for Los Angeles" do
    applicant = double(:location => "Los Angeles")
    output_crafters = subject.call(crafters, applicant)

    expect(output_crafters).to eq [los_angeles_crafter]
  end

  it "returns London's crafters if applicant is applying for London" do
    applicant = double(:location => "london")
    output_crafters = subject.call(crafters, applicant)

    expect(output_crafters).to eq [london_crafter]
  end
end
