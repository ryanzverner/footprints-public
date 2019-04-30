require 'applicant_dispatch/strategies/scoring_strategy'

module ApplicantDispatch
  module TestScorers
    PreferFirstTwo = ->(scoreable_crafter, applicant) {
      scoreable_crafter.each do |crafter|
        if [scoreable_crafter[0], scoreable_crafter[1]].include?(crafter)
          crafter.score += 1
        end
      end
    }
  end

  module Strategies
    describe ScoringStrategy do
      subject { described_class.new(TestScorers::PreferFirstTwo) }

      it "returns the highest scoring candidates" do
        one = double(:crafter_one)
        two = double(:crafter_two)
        three = double(:crafter_three)

        expect { |b| 
          subject.call([one, two, three], double(:applicant), &b)
        }.to yield_with_args([one, two])
      end
    end
  end
end
