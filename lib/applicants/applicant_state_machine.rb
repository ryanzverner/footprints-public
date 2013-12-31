class ApplicantStateMachine
  STATES = [
    'applied_on',
    'initial_reply_on',
    'sent_challenge_on',
    'completed_challenge_on',
    'reviewed_on',
    'offered_on',
    'decision_made_on'
  ]

  class << self

    def determine_state(applicant)
      STATES.reverse.find do |state|
        !applicant.send(state).nil?
      end
    end
  end
end
