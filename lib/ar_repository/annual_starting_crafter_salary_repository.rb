require 'ar_repository/models/annual_starting_crafter_salary'
require 'ar_repository/base_repository'

module ArRepository
  class AnnualStartingCrafterSalaryRepository
    include BaseRepository

    def model_class
      ::AnnualStartingCrafterSalary
    end

    def find_by_location(location)
      model_class.find_by_location(location)
    end

  end
end
