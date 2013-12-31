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

      it "increases a craftsman's score if she is seeking an apprentice" do
        craftsman = build_craftsman(is_seeking_for_applicant_skill: true)

        subject.call([craftsman], applicant)

        expect(craftsman.score).to eq(weight)
      end

      it "does not increase a craftsman's score if she is not seeking an apprentice" do
        craftsman = build_craftsman(is_seeking_for_applicant_skill: false)

        subject.call([craftsman], applicant)

        expect(craftsman.score).to eq(0)
      end

      def build_craftsman(args = {})
        is_seeking_for_applicant_skill = args.fetch(:is_seeking_for_applicant_skill)

        craftsman = double(:craftsman)
        allow(craftsman).to receive(:is_seeking_for?).with(applicants_skill) { is_seeking_for_applicant_skill }

        ScoreableEntity.new(craftsman)
      end
    end
  end
end
