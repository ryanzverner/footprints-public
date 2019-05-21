require 'ostruct'
require 'applicant_dispatch/strategies/scoring_strategy'
require 'applicant_dispatch/util/scoreable_entity'

module ApplicantDispatch
  module Scorers
    describe "SeekingScorer" do
      subject { SeekingScorer }

      let(:weight) { WEIGHT[:seeking_apprentice] }

      let(:applicant) { double(:applicant) }

      it "increases a crafter's score if she is seeking an apprentice" do
        crafter = build_crafter(seeking: true)

        subject.call([crafter], applicant)

        expect(crafter.score).to eq(weight)
      end

      it "does not increase a crafter's score if she is not seeking an apprentice" do
        crafter = build_crafter(seeking: false)

        subject.call([crafter], applicant)

        expect(crafter.score).to eq(0)
      end

      def build_crafter(args = {})
        seeking = args.fetch(:seeking)

        ScoreableEntity.new(double(:crafter, :seeking => seeking))
      end
    end
  end
end
