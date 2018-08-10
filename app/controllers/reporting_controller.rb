require 'reporting/reporting_interactor'

class ReportingController < ApplicationController
  before_filter :require_admin

  def index
    interactor = ReportingInteractor.new(session[:id_token])
    @reporting_data = interactor.fetch_projection_data(Date.today.month, Date.today.year)
    puts @reporting_data
    @reporting_data = { "Aug 2018" => { "Software Craftsmen" => repo.craftsman.where("skill = 2", 0).count,
                                              "UX Craftsmen" => repo.craftsman.where("skill = 1", 0).count,
                                              "Software Residents" => 99,
                                              "UX Residents" => 99,
                                              "Finishing Software Residents" => 99,
                                              "Finishing UX Residents" => 99,
                                              "Student Apprentices" => 99 } }
  # rescue ReportingInteractor::AuthenticationError => e
  #   error_message = "You are not authorized through warehouse to use this feature"

  #   Rails.logger.error(error_message)
  #   Rails.logger.error(e.message)
  #   Rails.logger.error(e.backtrace)

  #   redirect_to root_path, :flash => { :error => [error_message] }
  end
end
