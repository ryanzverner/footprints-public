require 'ar_repository/models/annual_starting_craftsman_salary'
require 'ar_repository/base_repository'

module ArRepository
  class AnnualStartingCraftsmanSalaryRepository
    include BaseRepository

    def model_class
      ::AnnualStartingCraftsmanSalary
    end

    def find_by_location(location)
      model_class.find_by_location(location)
    end

  end
end
