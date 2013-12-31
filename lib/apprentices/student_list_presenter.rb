require 'active_support/core_ext/array/conversions'

class StudentListPresenter
  def initialize(raw_apprenticeships)
    @raw_apprenticeships = raw_apprenticeships
  end

  def students
    @raw_apprenticeships.map { |raw| PresentedStudent.new(raw) }
  end

  private

  class PresentedStudent
    attr_reader :raw_apprenticeship

    def initialize(raw_apprenticeship)
      @raw_apprenticeship = raw_apprenticeship
    end

    def name(person = raw_apprenticeship[:person])
      first_name = person[:first_name].capitalize
      last_name = person[:last_name].capitalize

      "#{first_name} #{last_name}"
    end

    def email
      raw_apprenticeship[:person][:email]
    end

    def start_date
      raw_apprenticeship[:start]
    end

    def end_date
      raw_apprenticeship[:end]
    end

    def mentor_names
      raw_apprenticeship[:mentorships].map { |mentorship| 
        name(mentorship[:person])
      }.to_sentence
    end
  end
end
