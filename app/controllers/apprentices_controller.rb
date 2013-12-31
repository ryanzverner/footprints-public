require 'reporting/data_parser'
require 'apprentices/apprentices_interactor'
require 'apprentices/apprentice_list_presenter'
require 'apprentices/student_list_presenter'
require 'warehouse/identifiers'

class ApprenticesController < ApplicationController
  before_filter :require_admin

  def index
    begin
      raw_residents = interactor.fetch_all_residents
      raw_students = interactor.fetch_all_students

      @residents = ApprenticeListPresenter.new(raw_residents).residents
      @students = StudentListPresenter.new(raw_students).students
    rescue ApprenticesInteractor::AuthenticationError => e
      error_message = "You are not authorized through warehouse to use this feature"
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace)
      redirect_to root_path, :flash => { :error => [error_message] }
    end  
  end

  def edit
    raw_resident = interactor.fetch_resident_by_id(id)
    @resident = ApprenticeListPresenter::PresentedApprentice.new(raw_resident)
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
    params.require(:apprentice).permit(:end_date)
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
