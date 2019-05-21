require 'applicant_dispatch/strategies/filter_strategy'

describe "ApplicantDispatch::Filters::DisciplineFilter" do
  subject { ApplicantDispatch::Filters::DisciplineFilter }

  let(:software_crafter) { 
    double(:position => "Software Crafter")
  }

  let(:chicago_designer) { 
    double(:position => "Not a Software Crafter")
  }

  let(:reviewer_with_unknown_position) {
    double(:position => nil)
  }

  let(:crafters) { 
    [chicago_designer, software_crafter, reviewer_with_unknown_position]
  }

  it "returns all reviewers who are able to review applications" do
    output_crafters = subject.call(crafters, double)

    expect(output_crafters).to eq([software_crafter, reviewer_with_unknown_position])
  end
end
