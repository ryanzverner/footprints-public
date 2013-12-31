# encoding: utf-8
class ApplicantOfferLetterGenerator
  include ActionView::Helpers::NumberHelper
  attr_reader :applicant, :params

  def initialize(applicant, params)
    @applicant = applicant
    @params = params
  end

  def build_offer_letter_as_json
    offer_letter_template = get_template(applicant.location, applicant.skill)
    static = offer_letter_template.read.tr("\n", "")
    final_letter = insert_dynamic_content(static, placeholder_values)
  end

  private

  def get_template(location, skill)
    if location.downcase == "london"
      File.new("#{Rails.root}/lib/argon/uk_offer_letter_template.json")
    elsif location.downcase != "london" && skill.downcase == "student"
      File.new("#{Rails.root}/lib/argon/student_offer_letter_template.json")
    else
      File.new("#{Rails.root}/lib/argon/us_offer_letter_template.json")
    end
  end

  def insert_dynamic_content(static_json, placeholder_values)
    placeholder_values.each do |placeholder, value|
      static_json.gsub!(placeholder, value)
    end
    static_json
  end

  def get_apprentice_salary
    raw = Footprints::Repository.monthly_apprentice_salary.find_by_duration_at_location(params[:duration].to_i, applicant.location).amount
    number_to_currency(raw, currency_format_options(applicant.location))
  end

  def get_craftsman_salary
    raw = Footprints::Repository.annual_starting_craftsman_salary.find_by_location(applicant.location).amount
    number_to_currency(raw, currency_format_options(applicant.location))
  end

  def currency_format_options(location)
    if location == "London"
      {:unit => "£"}
    else
      {:unit => "$"}
    end
  end

  def placeholder_values
    [
      ["<TODAY'S DATE>", format_date(Date.today)],
      ["<APPLICANT NAME>", applicant.name],
      ["<MENTOR NAME>", applicant.assigned_craftsman],
      ["<START DATE>", format_date(applicant.start_date)],
      ["<END DATE>", format_date(applicant.end_date)],
      ["<DURATION>", params[:duration]],
      ["<APPRENTICE SALARY>", get_apprentice_salary],
      ["<CRAFTSMAN ANNUAL SALARY>", get_craftsman_salary],
      ["<PT FT>", params[:pt_ft]],
      ["<WITHDRAW OFFER DATE>", format_date(Date.parse(params[:withdraw_offer_date]))],
      ["<HOURS PER WEEK>", params[:hours_per_week]]
    ]
  end

  def format_date(date)
    if applicant.location == "London"
      date.strftime("%e %B %Y")
    else
      date.strftime("%B %e, %Y")
    end
  end
end
