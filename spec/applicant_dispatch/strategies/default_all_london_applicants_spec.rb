require 'applicant_dispatch/strategies/default_all_london_applicants'

module ApplicantDispatch
  module Strategies
    describe DefaultAllLondonApplicants do
      subject { described_class.new }

      let(:london_candidate) {
        double(:london_candidate,
               :email => "not_director@abcinc.com",
               :location => "London")
      }

      let(:london_director) {
        double(:london_director,
               :email => DefaultAllLondonApplicants::LONDON_DIRECTOR_EMAIL,
               :location => "London")
      }

      let(:chicago_candidate) {
        double(:chicago_candidate_one,
               :email => "not_director@abcinc.com",
               :location => "Chicago")
      }

      it "immediately returns the director of software services if the applicant is from london" do
        applicant = double(:applicant,
                           :location => "London")

        reviewer = subject.call([london_candidate, london_director, chicago_candidate], applicant)

        expect(reviewer).to eq(london_director)
      end

      it "yields the candidates to the next strategy if the applicant is not a london applicant" do
        applicant = double(:applicant,
                           :location => "Chicago")

        candidates = [london_candidate, london_director, chicago_candidate]

        expect { |b| subject.call(candidates, applicant, &b) }.to yield_with_args(candidates)
      end

      it "yield the candidates to the next strategy if the applicant's location is not present" do
        applicant = double(:applicant,
                           :location => nil)

        candidates = [london_candidate, london_director, chicago_candidate]

        expect { |b| subject.call(candidates, applicant, &b) }.to yield_with_args(candidates)
      end
    end
  end
end
