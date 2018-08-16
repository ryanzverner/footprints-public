require 'reporting/reporting_interactor'

class ReportingController < ApplicationController
  before_filter :require_admin

  def index
    interactor = ReportingInteractor.new(session[:id_token])
    @reporting_data = { 
      "Aug 2018" => 
      { "Software Craftsmen" => repo.craftsman.where("skill = 2", 0).count,
        "UX Craftsmen" => repo.craftsman.where("skill = 1", 0).count,
        "Software Apprentices" => repo.apprentice.where("position = 'developer'", 0).count,
        "UX Apprentices" => repo.apprentice.where("position = 'designer'", 0).count,
        "Software Applicants" => repo.applicant.where("discipline = 'developer'", 0).count,
        "UX Applicants" => repo.applicant.where("discipline = 'designer'", 0).count 
        } 
      }
    @reporting_data = interactor.fetch_projection_data(Date.today.month, Date.today.year)

    @test_data = repo.apprentice.all
    puts "%!#%(!#%^(*!#^)*!)#^!)#%&!)#*$)!*#%)!*#^)!&#^)&!#)$*!)#*%)!*#^!"
    puts "TEST DATA2: #{@test_data.inspect}"
    puts "%!#%(!#%^(*!#^)*!)#^!)#%&!)#*$)!*#%)!*#^)!&#^)&!#)$*!)#*%)!*#^!"
    
  # rescue ReportingInteractor::AuthenticationError => e
  #   error_message = "You are not authorized through warehouse to use this feature"

  #   Rails.logger.error(error_message)
  #   Rails.logger.error(e.message)
  #   Rails.logger.error(e.backtrace)

  #   redirect_to root_path, :flash => { :error => [error_message] }
  end
end
