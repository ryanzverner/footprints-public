require 'applicant_dispatch/util/scoreable_entity'

module ApplicantDispatch
  module Strategies
    class ScoringStrategy < Struct.new(:scorer)
      def call(candidates, applicant)
        scoreable_candidates = candidates.map do |candidate| 
          Scorers::ScoreableEntity.new(candidate)
        end

        scored_candidates = scorer.call(scoreable_candidates, applicant)

        highest_score = scored_candidates.map(&:score).max

        highest_scoring_candidates = scored_candidates.select do |candidate|
          candidate.score == highest_score
        end

        yield highest_scoring_candidates
      end

      private

      def sort_descending(candidates)
        candidates.sort_by(&:score).reverse
      end
    end
  end

  module Scorers
    WEIGHT = {
      :has_apprentice => -2,
      :each_assigned_applicant => -1,
      :seeking_apprentice => 2,
      :matching_skill_level => 5
    }

    HasApprenticeScorer = ->(scoreable_craftsmen, applicant) {
      scoreable_craftsmen.each do |scoreable_craftsman|
        if scoreable_craftsman.has_apprentice
          scoreable_craftsman.score += WEIGHT.fetch(:has_apprentice)
        end
      end
    }

    LoadScorer = ->(scoreable_craftsmen, applicant) {
      scoreable_craftsmen.each do |scoreable_craftsman|
        score = scoreable_craftsman.number_of_current_assigned_applicants * WEIGHT.fetch(:each_assigned_applicant)

        scoreable_craftsman.score += score
      end
    }

    SeekingScorer = ->(scoreable_craftsmen, applicant) {
      scoreable_craftsmen.each do |scoreable_craftsman|
        if scoreable_craftsman.seeking
          scoreable_craftsman.score += WEIGHT.fetch(:seeking_apprentice)
        end
      end
    }

    SkillScorer = ->(scoreable_craftsmen, applicant) {
      scoreable_craftsmen.each do |scoreable_craftsman|
        if scoreable_craftsman.is_seeking_for?(applicant.skill)
          scoreable_craftsman.score += WEIGHT.fetch(:matching_skill_level)
        end
      end
    }
  end
end
