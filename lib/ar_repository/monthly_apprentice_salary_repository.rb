require 'ar_repository/models/monthly_apprentice_salary'
require 'ar_repository/base_repository'

module ArRepository
  class MonthlyApprenticeSalaryRepository
    include BaseRepository

    def model_class
      ::MonthlyApprenticeSalary
    end

    def create(attributes = {})
      begin
        salary = model_class.new(attributes)
        salary.save!
        salary
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => invalid
        raise Footprints::RecordNotValid.new(salary)
      end
    end

    def find_all_durations_by_location(location)
      records = model_class.where(:location => location)
      records.collect {|x| x.duration}
    end

    def find_by_duration_at_location(duration, location)
      model_class.where(:location => location).find_by_duration(duration)
    end

    def find_by_id(id)
      model_class.find_by_id(id)
    end

    def destroy_by_id(id)
      model_class.destroy(id)
    end
  end
end
