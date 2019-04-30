require 'ostruct'
require 'applicant_dispatch/strategies/scoring_strategy'
require 'applicant_dispatch/util/scoreable_entity'

module ApplicantDispatch
  module Scorers
    describe "HasApprenticeScorer" do
      subject { HasApprenticeScorer }

      let(:weight) { WEIGHT[:has_apprentice] }
      let(:applicant) { double(:applicant) }

      it "decreases a crafter's score if she has an apprentice" do
        crafter = build_crafter(has_apprentice: true)

        subject.call([crafter], applicant)

        expect(crafter.score).to eq(weight)
      end

      it "does not decrease the score if she does not have an apprentice" do
        crafter = build_crafter(has_apprentice: false)

        subject.call([crafter], applicant)

        expect(crafter.score).to eq(0)
      end

      def build_crafter(args = {})
        has_apprentice = args.fetch(:has_apprentice)

        ScoreableEntity.new(double(:crafter, :has_apprentice => has_apprentice))
      end
    end
  end
end
