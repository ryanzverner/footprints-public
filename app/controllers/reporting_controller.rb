require 'reporting/reporting_interactor'

class ReportingController < ApplicationController
  before_filter :require_admin

  def index
    interactor = ReportingInteractor.new(session[:id_token])
    @reporting_data = interactor.fetch_projection_data(Date.today.month, Date.today.year)
  rescue ReportingInteractor::AuthenticationError => e
    error_message = "You are not authorized through warehouse to use this feature"

    Rails.logger.error(error_message)
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace)

    redirect_to root_path, :flash => { :error => [error_message] }
  end
end
