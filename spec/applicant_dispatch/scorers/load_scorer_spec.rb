require 'applicant_dispatch/strategies/scoring_strategy'
require 'applicant_dispatch/util/scoreable_entity'

module ApplicantDispatch
  module Scorers
    describe "LoadScorer" do
      subject { LoadScorer }

      let(:weight) {
        WEIGHT[:each_assigned_applicant]
      }

      let(:candidate_one) { 
        ScoreableEntity.new(double(:candidate_one,
                                   :number_of_current_assigned_applicants => 10))
      }

      let(:candidate_two) {
        ScoreableEntity.new(double(:candidate_two,
                                   :number_of_current_assigned_applicants => 2))
      }
                                  
      it "decreases a candidates score in relation to the amount of current assigned applicants" do
        subject.call([candidate_one, candidate_two], double(:applicant))

        expect(candidate_one.score).to eq(10 * weight)
        expect(candidate_two.score).to eq(2 * weight)
      end
    end
  end
end
