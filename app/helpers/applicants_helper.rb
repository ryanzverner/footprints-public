module ApplicantsHelper
  def format_label(field)
    field.to_s.titleize
  end

  def days_since_last_action(applicant)
    state = ApplicantStateMachine.determine_state(applicant)
    current_state_date = applicant.send(state)
    return "No Data Available" if current_state_date.nil?
    return (Date.today - current_state_date).to_i
  end

  def display_end_date(date)
    date ? format_date(date) : "N/A"
  end

  def format_date(date)
    date.strftime(month_day_year)
  end

  def display_date(date)
    date.strftime(month_day_year)
  end

  def month_day_year
    "%b %-d, %Y"
  end
end
