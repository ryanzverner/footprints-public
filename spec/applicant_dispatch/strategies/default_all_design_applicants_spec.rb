require 'applicant_dispatch/strategies/default_all_design_applicants'

module ApplicantDispatch
  module Strategies
    describe DefaultAllDesignApplicants do
      subject { described_class.new }

      let(:london_candidate) {
        double(:london_candidate,
               :email => "bob@abcinc.com")
      }

      let(:chicago_candidate) {
        double(:chicago_candidate_one,
               :email => "frank@abcinc.com")
      }

      let(:lead_designer) {
        double(:chicago_candidate_two,
               :email => DefaultAllDesignApplicants::LEAD_DESIGNER_EMAIL)
      }

      it "immediately returns the lead designer if the applicant is a design apprentice" do
        applicant = double(:applicant,
                           :discipline => "designer")

        reviewer = subject.call([london_candidate, chicago_candidate, lead_designer], applicant)

        expect(reviewer).to eq(lead_designer)
      end

      it "yields the candidates if the applicant is not a design apprentice" do
        applicant = double(:applicant,
                           :discipline => "not designer")

        candidates = [london_candidate, chicago_candidate, lead_designer]

        expect { |b| 
          subject.call(candidates, applicant, &b)
        }.to yield_with_args(candidates)
      end
    end
  end
end
