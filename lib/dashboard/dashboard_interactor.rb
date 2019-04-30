require 'applicant_dispatch/dispatcher'

class DashboardInteractor
  class InvalidAvailabilityDate < RuntimeError
  end

  attr_reader :crafter, :crafter_repo

  def initialize(crafter_repo)
    @crafter_repo = crafter_repo
  end

  def has_applicants?(crafter)
    assigned_applicants(crafter).count > 0
  end

  def decline_all_applicants_and_set_availability_date(crafter, date)
    update_crafter_availability_date(crafter, date)
    decline_all_applicants(crafter)
  end

  def decline_all_applicants(crafter)
    assigned_applicants(crafter).each do |applicant|
      decline_applicant(applicant)
      assign_new_crafter(applicant)
    end
  end

  def decline_applicant(applicant)
    applicant.update(:crafter_id =>  nil, :assigned_crafter => nil)
    applicant.assigned_crafter_records.map { |record| record.update_attribute(:current, false) }
  end

  def assigned_applicants(crafter)
    crafter.applicants.where(has_steward: false)
  end

  def update_crafter_availability_date(crafter, date)
    crafter.update!(unavailable_until: date) if has_applicants?(crafter)
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidAvailabilityDate.new('Date must be in the future')
  end

  def assign_steward_for_applicant(applicant)
    applicant.update(has_steward: true)
  end

  def confirmed_applicants(crafter)
    crafter ? crafter.applicants.where( { has_steward: true, archived: false } ) : []
  end

  def not_yet_responded_applicants(crafter)
    crafter ? crafter.applicants.where( { has_steward: false } ) : []
  end

  def assign_new_crafter(applicant)
    steward = crafter_repo.find_by_email(ENV['STEWARD'])

    ApplicantDispatch::Dispatcher.new(applicant, steward).assign_applicant
  end
end
