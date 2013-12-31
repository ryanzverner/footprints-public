class EmploymentDataGenerator
  attr_reader :parser

  def initialize(parser)
    @parser = parser
    @finished_residents = {}
  end

  def generate_data_for(month)
    reporting_date = Date.parse(month)

    craftsmen = total_craftsmen(reporting_date)
    residents = total_residents(reporting_date)
    finishing_residents = total_finishing_residents(reporting_date)

    craftsmen
      .merge(residents)
      .merge(finishing_residents)
      .merge(student_apprentices(reporting_date))
  end

  private

  def student_apprentices(reporting_date)
    parser.student_apprentices_for(reporting_date.month, reporting_date.year)
  end

  def total_craftsmen(reporting_date)
    craftsmen = parser.active_craftsmen_for(reporting_date.month, reporting_date.year)

    craftsmen["Software Craftsmen"] += @finished_residents.fetch("Software Residents", 0)
    craftsmen["UX Craftsmen"] += @finished_residents.fetch("UX Residents", 0)
    craftsmen
  end

  def total_residents(reporting_date)
    parser.active_residents_for(reporting_date.month, reporting_date.year)
  end

  def total_finishing_residents(reporting_date)
    residents_finishing(reporting_date).reduce({}) do |resulting_hash, (key, value)|
      # add_to_finished_residents_count(key => value)

      resulting_hash["Finishing " + key] = value
      resulting_hash
    end
  end

  def residents_finishing(reporting_date)
    parser.residents_finishing_in(reporting_date.month, reporting_date.year)
  end

  def add_to_finished_residents_count(new_residents)
    @finished_residents.merge!(new_residents) { |_, old_count, addend| old_count + addend }
  end
end
