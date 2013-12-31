class ApplicantPresenter
  attr_accessor :applied_on
  attr_reader :applicants

  def initialize(applicants = [])
    @applicants = applicants
  end

  def sort_by_date(applicants)
    applicants.sort! { |a,b| a.applied_on <=> b.applied_on }
  end

  def days_since_last_applied(application_date)
    (Date.today - application_date).to_i
  end

  def applicant_count
    applicants.count
  end

  def has_applicants?
    applicant_count > 0
  end
end

