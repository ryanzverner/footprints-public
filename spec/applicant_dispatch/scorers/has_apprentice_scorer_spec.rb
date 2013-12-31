require 'ostruct'
require 'applicant_dispatch/strategies/scoring_strategy'
require 'applicant_dispatch/util/scoreable_entity'

module ApplicantDispatch
  module Scorers
    describe "HasApprenticeScorer" do
      subject { HasApprenticeScorer }

      let(:weight) { WEIGHT[:has_apprentice] }
      let(:applicant) { double(:applicant) }

      it "decreases a craftsman's score if she has an apprentice" do
        craftsman = build_craftsman(has_apprentice: true)

        subject.call([craftsman], applicant)

        expect(craftsman.score).to eq(weight)
      end

      it "does not decrease the score if she does not have an apprentice" do
        craftsman = build_craftsman(has_apprentice: false)

        subject.call([craftsman], applicant)

        expect(craftsman.score).to eq(0)
      end

      def build_craftsman(args = {})
        has_apprentice = args.fetch(:has_apprentice)

        ScoreableEntity.new(double(:craftsman, :has_apprentice => has_apprentice))
      end
    end
  end
end
