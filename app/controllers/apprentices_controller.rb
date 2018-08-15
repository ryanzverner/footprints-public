require 'repository'
require 'reporting/data_parser'
require 'apprentices/apprentices_interactor'
require 'apprentices/apprentice_list_presenter'
require 'apprentices/student_list_presenter'
require 'warehouse/identifiers'
require 'ar_repository/apprentice_repository'

# require 'date'

# require 'applicant_dispatch/dispatcher'


class ApprenticesController < ApplicationController
  before_filter :require_admin

  def index
    begin
      @apprentices = Footprints::Repository.apprentice.all
    rescue ApprenticesInteractor::AuthenticationError => e
      error_message = "You are not authorized through warehouse to use this feature"
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace)
      redirect_to root_path, :flash => { :error => [error_message] }
    end  
  end

  def new
    @apprentice = repo.apprentice.new
  end

  def create
    @apprentice = repo.apprentice.new(apprentice_params)
    @apprentice.save!
    redirect_to(apprentices_path, :notice => "Successfully created #{@apprentice.name}")
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

  private

  def interactor
    @interactor ||= ApprenticesInteractor.new(session[:id_token])
  end

  def apprentice_params
    params.require(:apprentice).permit(:name, :email, :applied_on, :position, :location, :start_date, :end_date, :mentor)
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

  # EDITED Below

  #  def new
  #   @residents = repo.apprentices.new
  # end

  # def create
  #   @applicant = repo.applicant.new(applicant_params)
  #   @applicant.save!
  #   redirect_to(applicant_path(@applicant), :notice => "Successfully created #{@applicant.name}")
  # rescue StandardError => e
  #   flash.now[:error] = [e.message]
  #   render :new
  # endf

end





