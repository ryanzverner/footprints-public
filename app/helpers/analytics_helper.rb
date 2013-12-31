require 'ar_repository/applicant_repository'
require 'applicants/applicant_state_machine'
module AnalyticsHelper

  def repo
    Footprints::Repository
  end

  def average_lapse_time(ending, starting)
    applicants_at_end_state = repo.applicant.get_applicants_by_state('decision_made_on')
    applicants = applicants_at_end_state.select { |app| app.send(ending) != nil && app.send(starting) != nil }
    return "Not enough data" if applicants.count == 0
    days = 0
    applicants.each do |app|
      time_lapse = (app.send(ending) - app.send(starting)).to_i
      days += time_lapse
    end
    (days/applicants.count).to_s + " days"
  end

  def fall_off(field, days)
    applicants_at_state = repo.applicant.get_applicants_by_state(field)
    return "Not enough data" if applicants_at_state.count == 0
    apps_fall_off = applicants_at_state.select do |app|
      (Date.today - app.send(field)) >= days
    end
    (((apps_fall_off.length.to_f) / (Applicant.all.length.to_f)) * 100).round.to_s + "%"
  end

  def get_background_percentage(field, value)
    total = get_background_count(field, value)
    ((total.to_f) / (Applicant.all.length.to_f) * 100).round(2).to_s + "%"
  end

  def get_background_count(field, value)
    Applicant.where(field => value).count
  end

  def display_background_info(field, value)
    percent = get_background_percentage(field, value)
    count = get_background_count(field, value)
    "#{percent} / #{count} applicants"
  end
end
