require './lib/applicants/applicant_index_presenter'
require './lib/dashboard/dashboard_interactor'

class DashboardController < ApplicationController
  before_filter :authenticate, :employee?

  def index
    @crafter = current_user.crafter
    @confirmed_applicants = interactor.confirmed_applicants(@crafter)
    @not_yet_responded_applicants = interactor.not_yet_responded_applicants(@crafter)
    @presenter = ApplicantIndexPresenter.new(@confirmed_applicants)
  end

  def confirm_applicant_assignment
    @applicant = repo.applicant.find_by_id(params[:id])
    interactor.assign_steward_for_applicant(@applicant)
    redirect_to root_path, :notice => "Confirmed"
  end

  def decline_applicant_assignment
    @applicant = repo.applicant.find_by_id(params[:id])
    interactor.decline_applicant(@applicant)
    interactor.assign_new_crafter(@applicant)
    redirect_to root_path, :notice => "Declined"
  end

  def decline_all_applicants
    crafter = current_user.crafter
    interactor.decline_all_applicants_and_set_availability_date(crafter, params[:unavailable_until])
    redirect_to root_path, :notice => "Declined All Applicants"
  rescue DashboardInteractor::InvalidAvailabilityDate => e
    redirect_to root_path, flash: { error: [e.message] }
  end

  private

  def interactor
    DashboardInteractor.new(repo.crafter)
  end
end
