require 'applicant_dispatch/find_best_applicant_reviewer'

module TestStrategies
  class OnlyApplicantsInChicago
    def call(candidates, applicant)
      chicago_candidates = candidates.reject do |candidate| 
        candidate.location != "Chicago"
      end

      yield(chicago_candidates)
    end
  end

  class AlwaysChooseFirstLondonCandidate
    def call(candidates, applicant)
      london_candidates = candidates.select do |candidate|
        candidate.location == "London"
      end

      london_candidates.first
    end
  end

  class DontAllowAnyone
    def call(*)
      yield []
    end
  end

  class BlowUp
    def call(*)
      raise StandardError, "The blow up strategy was invoked and should not have been"
    end
  end
end

module ApplicantDispatch
  describe FindBestApplicantReviewer do
    let(:applicant) { double(:applicant) }
    let(:fallback) { double(:applicant_steward) }

    let(:london_candidate) {
      double(:london_candidate,
             :importance => 1,
             :location => "London")
    }

    let(:chicago_candidate_one) {
      double(:chicago_candidate_one,
             :importance => 2,
             :location => "Chicago")
    }

    let(:chicago_candidate_two) {
      double(:chicago_candidate_two,
             :importance => 3,
             :location => "Chicago")
    }

    def get_best_candidate(*strategies)
      subject = described_class.new(
        settle_tie_with: ->(choices) { choices.first },
        :applicant => applicant,
        :fallback => fallback)

      subject.call(
        strategies: strategies,
        candidates: [
          chicago_candidate_one, 
          chicago_candidate_two,
          london_candidate
        ])
    end

    it "chooses a reviewer from the results of the given strategies" do
      best_candidate = get_best_candidate(TestStrategies::OnlyApplicantsInChicago.new)

      expect(best_candidate).to eq(chicago_candidate_one)
    end

    it "enables short-circuiting of the filtering process" do
      best_candidate = get_best_candidate(TestStrategies::AlwaysChooseFirstLondonCandidate.new, 
                                          TestStrategies::BlowUp.new)

      expect(best_candidate).to eq(london_candidate)
    end

    it "chooses the fallback option if the strategies return no possibilites" do
      best_candidate = get_best_candidate(TestStrategies::DontAllowAnyone.new, 
                                          TestStrategies::OnlyApplicantsInChicago.new)

      expect(best_candidate).to eq(fallback)
    end

    it "does not evaluate any more strategies if there are no possible candidates" do
      best_candidate = get_best_candidate(TestStrategies::DontAllowAnyone.new, 
                                          TestStrategies::BlowUp.new)

      expect(best_candidate).to eq(fallback)
    end
  end
end
