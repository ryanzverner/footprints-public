require 'applicant_dispatch/dispatcher'

class DashboardInteractor
  class InvalidAvailabilityDate < RuntimeError
  end

  attr_reader :craftsman, :craftsman_repo

  def initialize(craftsman_repo)
    @craftsman_repo = craftsman_repo
  end

  def has_applicants?(craftsman)
    assigned_applicants(craftsman).count > 0
  end

  def decline_all_applicants_and_set_availability_date(craftsman, date)
    update_craftsman_availability_date(craftsman, date)
    decline_all_applicants(craftsman)
  end

  def decline_all_applicants(craftsman)
    assigned_applicants(craftsman).each do |applicant|
      decline_applicant(applicant)
      assign_new_craftsman(applicant)
    end
  end

  def decline_applicant(applicant)
    applicant.update(:craftsman_id =>  nil, :assigned_craftsman => nil)
    applicant.assigned_craftsman_records.map { |record| record.update_attribute(:current, false) }
  end

  def assigned_applicants(craftsman)
    craftsman.applicants.where(has_steward: false)
  end

  def update_craftsman_availability_date(craftsman, date)
    craftsman.update!(unavailable_until: date) if has_applicants?(craftsman)
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidAvailabilityDate.new('Date must be in the future')
  end

  def assign_steward_for_applicant(applicant)
    applicant.update(has_steward: true)
  end

  def confirmed_applicants(craftsman)
    craftsman ? craftsman.applicants.where( { has_steward: true, archived: false } ) : []
  end

  def not_yet_responded_applicants(craftsman)
    craftsman ? craftsman.applicants.where( { has_steward: false } ) : []
  end

  def assign_new_craftsman(applicant)
    steward = craftsman_repo.find_by_email(ENV['STEWARD'])

    ApplicantDispatch::Dispatcher.new(applicant, steward).assign_applicant
  end
end
