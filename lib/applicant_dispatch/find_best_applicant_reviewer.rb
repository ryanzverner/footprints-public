require 'applicant_dispatch/strategies/filter_strategy'
require 'applicant_dispatch/strategies/scoring_strategy'
require 'applicant_dispatch/strategies/default_all_design_applicants'
require 'applicant_dispatch/strategies/default_all_london_applicants'
require 'applicant_dispatch/strategies/default_all_los_angeles_applicants'

require 'applicant_dispatch/util/aggregate'

module ApplicantDispatch
  PRODUCTION_STRATEGIES = [

    Strategies::DefaultAllLondonApplicants.new,
    Strategies::DefaultAllLosAngelesApplicants.new,
    Strategies::DefaultAllDesignApplicants.new,

    Strategies::FilterStrategy.new(
      Aggregate.new(
        Filters::AvailabilityFilter,
        Filters::LocationFilter,
        Filters::DisciplineFilter,
        Filters::PreviouslyDeniedFilter)),

    Strategies::ScoringStrategy.new(
      Aggregate.new(
        Scorers::SkillScorer,
        Scorers::HasApprenticeScorer,
        Scorers::SeekingScorer,
        Scorers::LoadScorer))
  ]

  class FindBestApplicantReviewer
    RandomChoice = ->(choices) { choices.sample }

    attr_reader :applicant, :fallback, :settle_tie

    def initialize(args = {})
      @settle_tie = args.fetch(:settle_tie_with) { RandomChoice }
      @applicant = args.fetch(:applicant)
      @fallback = args.fetch(:fallback)
    end

    def call(args = {})
      candidates = args.fetch(:candidates)
      strategies = args.fetch(:strategies) { PRODUCTION_STRATEGIES }

      if strategies.any? 
        first, *rest = strategies

        first.call(candidates, applicant) do |updated_candidate_list|
          if updated_candidate_list.any?
            call(candidates: updated_candidate_list, 
                 strategies: rest)
          else
            fallback
          end
        end
      else
        settle_tie.call(candidates)
      end
    end
  end
end
