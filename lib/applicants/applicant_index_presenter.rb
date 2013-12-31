class ApplicantIndexPresenter

  def initialize(applicants)
    @applicants = applicants
  end

  def offer_text(app)
    if applied_as_student?(app)
      "Welcome Student"
    else
      "Extend Offer"
    end
  end

  def no_results_message
    "No Results" if @applicants.empty?
  end

  def tooltip_state(app, state)
    "current-state" if ApplicantStateMachine.determine_state(app) == state
  end

  def current_state(app)
    state = ApplicantStateMachine.determine_state(app)
    DISPLAY_STATES[state]["current"]
  end

  def waiting_state(app)
    state = ApplicantStateMachine.determine_state(app)
    DISPLAY_STATES[state]["waiting"]
  end

  def waiting_state_class(app)
    state = ApplicantStateMachine.determine_state(app)
    if app.archived
      "folder-open-o"
    else
      DISPLAY_STATES[state]["court"]
    end
  end

  def skill(applicant)
    applicant.skill.try(:capitalize)
  end

  def discipline(applicant)
    applicant.discipline.try(:capitalize)
  end

  def location(applicant)
    applicant.location.try(:titleize)
  end

  DISPLAY_STATES = {
    "applied_on" =>
    { "current" => "Applied",
      "waiting" => "Need to contact",
      "court" => "exclamation" },
    "initial_reply_on" =>
    { "current" => "Contacted",
      "waiting" => "Waiting to hear back",
      "court" => "clock-o" },
    "sent_challenge_on" =>
    { "current" => "Requested Submission",
      "waiting" => "Waiting for submission",
      "court" => "clock-o" },
    "completed_challenge_on" =>
    { "current" => "Submitted Code",
      "waiting" => "Pending submission review",
      "court" => "exclamation" },
    "reviewed_on" =>
    { "current" => "Received Feedback",
      "waiting" => "Need to extend offer",
      "court" => "exclamation"},
    "offered_on" =>
    { "current" => "Extended Offer",
      "waiting" => "Pending offer letter",
      "court" => "clock-o"},
    "decision_made_on" =>
    { "current" => "Completed Application",
      "waiting" => "Completed Application",
      "court" => "folder-open-o" }
  }

  private

  def applied_as_student?(app)
    app.skill == "Student"
  end

end
