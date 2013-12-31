require 'ostruct'
require 'applicant_dispatch/strategies/scoring_strategy'
require 'applicant_dispatch/util/scoreable_entity'

module ApplicantDispatch
  module Scorers
    describe "SeekingScorer" do
      subject { SeekingScorer }

      let(:weight) { WEIGHT[:seeking_apprentice] }

      let(:applicant) { double(:applicant) }

      it "increases a craftsman's score if she is seeking an apprentice" do
        craftsman = build_craftsman(seeking: true)

        subject.call([craftsman], applicant)

        expect(craftsman.score).to eq(weight)
      end

      it "does not increase a craftsman's score if she is not seeking an apprentice" do
        craftsman = build_craftsman(seeking: false)

        subject.call([craftsman], applicant)

        expect(craftsman.score).to eq(0)
      end

      def build_craftsman(args = {})
        seeking = args.fetch(:seeking)

        ScoreableEntity.new(double(:craftsman, :seeking => seeking))
      end
    end
  end
end
