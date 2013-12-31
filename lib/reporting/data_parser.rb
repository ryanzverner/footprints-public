require 'warehouse/identifiers'

class DataParser
  attr_reader :employment_data, :apprenticeships

  def initialize(employment_data, apprenticeships = [])
    @apprenticeships = apprenticeships
    @employment_data = employment_data
  end

  def active_craftsmen_for(month, year)
    all_craftsmen.reduce({}) do |resulting_hash, (position, employments)|
      resulting_hash[position] = number_of_active_employments(month, year, employments)
      resulting_hash
    end
  end

  def active_residents_for(month, year)
    all_residents.reduce({}) do |resulting_hash, (position, employments)|
      resulting_hash[position] = number_of_active_employments(month, year, employments)
      resulting_hash
    end
  end

  def residents_finishing_in(month, year)
    all_residents.reduce({}) do |resulting_hash, (position, employments)|
      resulting_hash[position] = number_of_finishing_employments(month, year, employments)
      resulting_hash
    end
  end

  def student_apprentices_for(month, year)
    students = apprenticeships.select { |a|
      a[:skill_level] == "student"
    }

    apprentice_count = students.select { |a|
      (a[:start]..a[:end]).cover?(Date.parse("#{month}/#{year}"))
    }.count

    {"Student Apprentices" => apprentice_count}
  end

  def all_craftsmen
    { "Software Craftsmen" => all_records_for(Warehouse::CRAFTSMAN_POSITION_NAMES[:developer], employment_data),
      "UX Craftsmen" => all_records_for(Warehouse::CRAFTSMAN_POSITION_NAMES[:designer], employment_data) }
  end

  def all_residents
    { "Software Residents" => all_records_for(Warehouse::APPRENTICE_POSITION_NAMES[:developer], employment_data),
      "UX Residents" => all_records_for(Warehouse::APPRENTICE_POSITION_NAMES[:designer], employment_data) }
  end

  private

  def all_records_for(position, employments)
    results = employments.select do |employment|
      employment_position_matches?(position, employment)
    end
    results.map { |employment| convert_employment_record(employment) }
  end

  def employment_position_matches?(position, employment)
    employment[:position][:name] == position
  end

  def convert_employment_record(employment)
    { id: employment[:person_id], start_date: employment[:start], end_date: employment[:end] }
  end

  def number_of_active_employments(month, year, employments)
    employments.select { |employment| is_active_in?(month, year, employment) }.count
  end

  def number_of_finishing_employments(month, year, employments)
    employments.select { |employment| finishing_in?(month, year, employment) }.count
  end

  def finishing_in?(month, year, employment)
    date = end_of_employment(employment)
    date.month == month && date.year == year
  end

  def is_active_in?(month, year, employment)
    (start_of_employment(employment)..end_of_employment(employment)).cover?(Date.parse("#{month}/#{year}"))
  end

  def start_of_employment(employment)
    employment[:start_date].to_date
  end

  def end_of_employment(employment)
    employment[:end_date].nil? ? Date.parse("9999-12-31") : employment[:end_date].to_date
  end
end
