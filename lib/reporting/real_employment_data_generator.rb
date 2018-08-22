class RealEmploymentDataGenerator
  attr_reader :parser

  def initialize(parser)
    @parser = parser
    @finished_apprentices = {}
  end

  def generate_data_for(month)
    reporting_date = Date.parse(month)

    crafters = total_crafters(reporting_date)
    apprentices = total_apprentices(reporting_date)
    finishing_apprentices = total_finishing_apprentices(reporting_date)

    crafters
      .merge(apprentices)
      .merge(finishing_apprentices)
  end

  private

  def total_crafters(reporting_date)
    crafters = parser.active_crafters_for(reporting_date.month, reporting_date.year)

    crafters["Software Crafters"] += @finished_apprentices.fetch("Software Apprentices", 0)
    crafters["UX Crafters"] += @finished_apprentices.fetch("UX Apprentices", 0)
    crafters
  end

  def total_apprentices(reporting_date)
    parser.active_apprentices_for(reporting_date.month, reporting_date.year)
  end

  def total_finishing_apprentices(reporting_date)
    residents_finishing(reporting_date).reduce({}) do |resulting_hash, (key, value)|

      resulting_hash["Finishing " + key] = value
      resulting_hash
    end
  end

  def residents_finishing(reporting_date)
    parser.apprentices_finishing_in(reporting_date.month, reporting_date.year)
  end
end
