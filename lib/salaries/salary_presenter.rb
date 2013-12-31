# encoding: utf-8
class SalaryPresenter
  def initialize(monthly_salaries = [], annual_salaries = [], params = {})
    @monthly_salaries = monthly_salaries
    @annual_salaries = annual_salaries
    @params = params
  end

  def current_city
    @params["city"]
  end

  def locations
    @locations ||= (@monthly_salaries + @annual_salaries).map(&:location).uniq.sort
  end

  def current_city_currency_symbol
    CURRENCY_SYMBOLS[@params["city"]]
  end

  def currency_symbol(location)
    CURRENCY_SYMBOLS[location]
  end

  def monthly_salaries_by_location(location)
    all_salaries_at_location = get_monthly_salaries_at_location(location)
    extract_salary_data(all_salaries_at_location)
  end

  def annual_salaries_by_location
    present_hash = {}

    locations.each do |location|
      raw_amount = get_annual_salary_at_location(location).amount
      present_hash[location] = "%.2f" % raw_amount
    end

    present_hash
  end

  private

  CURRENCY_SYMBOLS = { "Chicago" => "$", "London" => "£", "Los Angeles" => "$" }

  def get_monthly_salaries_at_location(location)
    @monthly_salaries.select{ |salary| salary.location == location }.sort_by(&:duration)
  end

  def get_annual_salary_at_location(location)
    @annual_salaries.select{ |salary| salary.location == location }.first
  end

  def extract_salary_data(salaries)
    salaries.map{ |salary| [salary.id, salary.duration, "%.2f" % salary.amount] }
  end
end
