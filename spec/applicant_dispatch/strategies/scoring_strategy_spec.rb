require 'applicant_dispatch/strategies/scoring_strategy'

module ApplicantDispatch
  module TestScorers
    PreferFirstTwo = ->(scoreable_craftsman, applicant) {
      scoreable_craftsman.each do |craftsman|
        if [scoreable_craftsman[0], scoreable_craftsman[1]].include?(craftsman)
          craftsman.score += 1
        end
      end
    }
  end

  module Strategies
    describe ScoringStrategy do
      subject { described_class.new(TestScorers::PreferFirstTwo) }

      it "returns the highest scoring candidates" do
        one = double(:craftsman_one)
        two = double(:craftsman_two)
        three = double(:craftsman_three)

        expect { |b| 
          subject.call([one, two, three], double(:applicant), &b)
        }.to yield_with_args([one, two])
      end
    end
  end
end
