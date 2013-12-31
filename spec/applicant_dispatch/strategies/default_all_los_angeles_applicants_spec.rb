require 'applicant_dispatch/strategies/default_all_los_angeles_applicants'

module ApplicantDispatch
  module Strategies
    describe DefaultAllLosAngelesApplicants do
      subject { described_class.new }

      let(:la_candidate) {
        double(:la_candidate,
               :email => "not_director@abcinc.com",
               :location => "London")
      }

      let(:la_director) {
        double(:la_director,
               :email => DefaultAllLosAngelesApplicants::LOS_ANGELES_DIRECTOR_EMAIL,
               :location => "London")
      }

      let(:chicago_candidate) {
        double(:chicago_candidate_one,
               :email => "not_director@abcinc.com",
               :location => "Chicago")
      }

      it "immediately returns the director of software services if the applicant is from los angeles" do
        applicant = double(:applicant,
                           :location => "Los Angeles")

        reviewer = subject.call([la_candidate, la_director, chicago_candidate], applicant)

        expect(reviewer).to eq(la_director)
      end

      it "yields the candidates to the next strategy if the applicant is not a london applicant" do
        applicant = double(:applicant,
                           :location => "Chicago")

        candidates = [la_candidate, la_director, chicago_candidate]

        expect { |b| subject.call(candidates, applicant, &b) }.to yield_with_args(candidates)
      end

      it "yield the candidates to the next strategy if the applicant's location is not present" do
        applicant = double(:applicant,
                           :location => nil)

        candidates = [la_candidate, la_director, chicago_candidate]

        expect { |b| subject.call(candidates, applicant, &b) }.to yield_with_args(candidates)
      end
    end
  end
end
