require 'argon/offer_letter_post'

class GenerateOnboardingLetter
  attr_reader :applicant, :template_root

  def initialize(applicant, template_root)
    @applicant = applicant
    @template_root = template_root
  end

  def call
    template = File.read("#{template_root}/#{template_name}")

    start_date = format_date_for_location(applicant.location, applicant.start_date)
    end_date = format_date_for_location(applicant.location, applicant.end_date)

    template = replace_start_date(start_date, template)
    template = replace_end_date(end_date, template)

    OfferLetterPost.get_pdf(template)
  end

  private

  def replace_start_date(start_date, template)
    template.gsub("<START DATE>", start_date)
  end

  def replace_end_date(end_date, template)
    template.gsub("<END DATE>", end_date)
  end

  def template_name
    if applicant.location.downcase == 'london'
      "uk_onboarding_template.json"
    elsif applicant.location.downcase != "london" && applicant.skill.downcase == "student"
      "student_onboarding_template.json"
    else
      "us_onboarding_template.json"
    end
  end

  def format_date_for_location(location, date)
    if location == "London"
      date.strftime("%e %B %Y")
    else
      date.strftime("%B %e, %Y")
    end
  end
end
