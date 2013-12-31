require 'applicant_dispatch/strategies/filter_strategy'

describe "ApplicantDispatch::Filters::DisciplineFilter" do
  subject { ApplicantDispatch::Filters::DisciplineFilter }

  let(:software_craftsman) { 
    double(:position => "Software Craftsman")
  }

  let(:chicago_designer) { 
    double(:position => "Not a Software Craftsman")
  }

  let(:reviewer_with_unknown_position) {
    double(:position => nil)
  }

  let(:craftsmen) { 
    [chicago_designer, software_craftsman, reviewer_with_unknown_position]
  }

  it "returns all reviewers who are able to review applications" do
    output_craftsmen = subject.call(craftsmen, double)

    expect(output_craftsmen).to eq([software_craftsman, reviewer_with_unknown_position])
  end
end
