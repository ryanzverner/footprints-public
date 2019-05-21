require 'ostruct'
require 'applicant_dispatch/strategies/scoring_strategy'
require 'applicant_dispatch/util/scoreable_entity'

module ApplicantDispatch
  module Scorers
    describe "SkillScorer" do
      subject { SkillScorer }

      let(:weight) { WEIGHT[:matching_skill_level] }
      let(:applicants_skill) { "Ping Pong" }
      let(:applicant) { double(:applicant, :skill => applicants_skill) }

      it "increases a crafter's score if she is seeking an apprentice" do
        crafter = build_crafter(is_seeking_for_applicant_skill: true)

        subject.call([crafter], applicant)

        expect(crafter.score).to eq(weight)
      end

      it "does not increase a crafter's score if she is not seeking an apprentice" do
        crafter = build_crafter(is_seeking_for_applicant_skill: false)

        subject.call([crafter], applicant)

        expect(crafter.score).to eq(0)
      end

      def build_crafter(args = {})
        is_seeking_for_applicant_skill = args.fetch(:is_seeking_for_applicant_skill)

        crafter = double(:crafter)
        allow(crafter).to receive(:is_seeking_for?).with(applicants_skill) { is_seeking_for_applicant_skill }

        ScoreableEntity.new(crafter)
      end
    end
  end
end
