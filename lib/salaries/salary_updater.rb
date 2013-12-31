class SalaryUpdater

  def initialize(params)
    @params = params
  end

  def create_monthly
    clean_amount = clean_user_input_salary(@params["amount"])
    Footprints::Repository.monthly_apprentice_salary.create(:location => @params["location"],
                                                            :duration => @params["duration"],
                                                            :amount   => clean_amount)
  end

  def update
    update_monthly_salaries
    update_annual_salaries
  end

  def destroy
    Footprints::Repository.monthly_apprentice_salary.destroy_by_id(@params['id'])
  end

  private

  def update_monthly_salaries
    @params["monthly"].each do |location, monthly_amounts|
      monthly_amounts.each do |duration, amount|
        update_monthly_salary(duration, location, amount)
      end
    end
  end

  def update_annual_salaries
    @params["annual"].each do |location, amount|
      update_annual_salary(location, amount)
    end
  end

  def update_monthly_salary(duration, location, amount)
    salary_record = Footprints::Repository.monthly_apprentice_salary.find_by_duration_at_location(duration, location)
    clean_amount = clean_user_input_salary(amount)
    salary_record.update_attribute(:amount, clean_amount)
  end

  def update_annual_salary(location, amount)
    salary_record = Footprints::Repository.annual_starting_craftsman_salary.find_by_location(location)
    clean_amount = clean_user_input_salary(amount)
    salary_record.update_attribute(:amount, clean_amount)
  end

  def clean_user_input_salary(input)
    input.gsub(/[^0-9\.]/, "")
  end

end
