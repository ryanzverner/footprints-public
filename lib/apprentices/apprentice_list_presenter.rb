class ApprenticeListPresenter
  attr_reader :raw_residents

  def initialize(raw_residents)
    @raw_residents = raw_residents
  end

  def residents
    raw_residents.map { |r| PresentedApprentice.new(r) }
  end

  class PresentedApprentice
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def name
      "#{first_name} #{last_name}"
    end

    def start_date
      data[:start]
    end

    def end_date
      data[:end]
    end

    def email
      data[:person][:email]
    end

    def employment_id
      data[:id]
    end

    def person_id
      data[:person][:id]
    end

    private

    def first_name
      data[:person][:first_name]
    end

    def last_name
      data[:person][:last_name]
    end
  end
end
