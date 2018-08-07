require 'reporting/data_parser'
require 'apprentices/apprentices_interactor'
require 'apprentices/apprentice_list_presenter'
require 'apprentices/student_list_presenter'
require 'warehouse/identifiers'

require 'applicants/applicant_interactor'
require 'applicants/eighthlight_applicants_interactor'
require 'repository'
require 'date'

# require 'applicant_dispatch/dispatcher'

class ApprenticesController < ApplicationController
  include ApplicantsHelper

  before_filter :require_admin

  def index
    begin
      @residents = Footprints::Repository.applicant.get_all_hired_residents
      @students =  Footprints::Repository.applicant.get_all_hired_students
    rescue ApprenticesInteractor::AuthenticationError => e
      error_message = "You are not authorized through warehouse to use this feature"
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace)
      redirect_to root_path, :flash => { :error => [error_message] }
    end
  end

  def new
    @applicant = repo.applicant.new
  end

  def create
    @applicant = repo.applicant.new(apprentice_params)
    #binding.pry
    @applicant.save!
    redirect_to(applicant_path(@applicant), :notice => "Successfully created #{@applicant.name}")
  rescue StandardError => e
    flash.now[:error] = [e.message]
    render :new
  end

  def edit
    @resident = Footprints::Repository.applicant.find_by_id(id)
  end

  def update
    begin
      raw_resident = interactor.fetch_resident_by_id(id)
      interactor.modify_resident_end_date!(raw_resident, end_date)
      interactor.modify_corresponding_craftsman_start_date!(raw_resident, next_monday(end_date))
      redirect_to "/apprentices/"
    rescue ArgumentError => e
      error_message = "Please provide a valid date"
      redirect_to "/apprentices/#{id}", :flash => { :error => [error_message] }
    end
  end

  def submit
    status, body = EighthlightApplicantsInteractor.apply(eighthlight_apprentice_params)
    render :status => status, :text => body, :layout => false
  end

  private

  def interactor
    @interactor ||= ApprenticesInteractor.new(session[:id_token])
  end

  def eighthlight_apprentice_params
    {
      :name              => params[:name],
      :email             => params[:email],
      :skill             => params[:position],
      :start_date        => params[:start_date],
      :end_date          => params[:end_date],
      :hired             => "yes",
      :applied_on        => Time.zone.now.to_date
      # :discipline        => params[:type],
      # :location          => params[:location],
      # :mentor            => params[:mentor]
    }
  end

  def apprentice_params
    params.require(:apprentice).permit(:name, :email, :skill, :start_date, :end_date, :hired, :applied_on)
  end

  def id
    params[:id].to_i
  end

  def end_date
    DateTime.parse(apprentice_params[:end_date])
  end

  def next_monday(date)
    date.next_week.at_beginning_of_week
  end

end
