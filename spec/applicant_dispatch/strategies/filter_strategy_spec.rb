require 'applicant_dispatch/strategies/filter_strategy'

module ApplicantDispatch
  module TestScorers
    OnlyAllowFirstTwo = ->(scoreable_craftsman, applicant) {
      scoreable_craftsman[0..1]
    }
  end

  module Strategies
    describe FilterStrategy do
      subject { described_class.new(TestScorers::OnlyAllowFirstTwo) }

      it "returns the filtered candidates according to the given filters" do
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
