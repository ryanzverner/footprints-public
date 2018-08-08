require 'applicants/applicant_finder'
require 'repository'
class ApprenticesController < ApplicationController
	def index
	end

	def create
		@apprentice = repo.apprentice.new
	end

	def applicant_params
    params.require(:apprentice).permit(:name, :email, :applied_on, :start_date, :end_date, :mentor, :discipline, :location)
  end
end
