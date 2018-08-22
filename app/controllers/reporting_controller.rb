require 'reporting/reporting_interactor'

class ReportingController < ApplicationController
  before_filter :require_admin

  def index
    interactor = ReportingInteractor.new(session[:id_token])
    if params[:location]
      @reporting_data = interactor.fetch_projection_data(params[:location], Date.today.month, Date.today.year)
    else
      @reporting_data = interactor.fetch_projection_data("all", Date.today.month, Date.today.year)
    end
  # rescue ReportingInteractor::AuthenticationError => e
  #   error_message = "You are not authorized through warehouse to use this feature"

  #   Rails.logger.error(error_message)
  #   Rails.logger.error(e.message)
  #   Rails.logger.error(e.backtrace)

  #   redirect_to root_path, :flash => { :error => [error_message] }
  end
end
