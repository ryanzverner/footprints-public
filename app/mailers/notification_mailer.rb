require './lib/applicants/applicant_presenter'

class NotificationMailer < ActionMailer::Base
  default :from => "noreply@abcinc.com"

  def applicant_request(crafter, applicant)
    @crafter = crafter
    @applicant = applicant

    mail :to => Rails.env.staging? ? ENV["TEST_EMAIL"] : crafter.email,
      :bcc => ENV["FOOTPRINTS_TEAM"], :subject => "[Footprints] You're the steward for #{@applicant.name}"
  end

  def crafter_reminder(applicant)
    @crafter = applicant.crafter
    @applicant = applicant

    mail :to => Rails.env.staging? ? ENV["TEST_EMAIL"] : @crafter.email, :subject => "[Footprints] REMINDER: You're the steward for #{@applicant.name}"
  end

  def steward_reminder(applicant)
    @applicant = applicant
    @crafter = applicant.crafter

    mail :to => ENV["FOOTPRINTS_TEAM"], :subject => "[Footprints] REMINDER: #{@crafter.name} has not responded regarding #{@applicant.name}"
  end

  def new_crafter_transfer(prev_crafter, new_crafter, applicant)
    @applicant = applicant
    @prev_crafter = prev_crafter
    @new_crafter = new_crafter

    mail :to => Rails.env.staging? ? ENV["TEST_EMAIL"] : @new_crafter.email, :subject => "[Footprints] You are now the steward for #{@applicant.name}"
  end

  def prev_crafter_transfer(prev_crafter, new_crafter, applicant)
    @applicant = applicant
    @prev_crafter = prev_crafter
    @new_crafter = new_crafter

    mail :to => Rails.env.staging? ? ENV["TEST_EMAIL"] : @prev_crafter.email, :subject => "[Footprints] #{@new_crafter.name} is now the steward for #{@applicant.name}"
  end

  def offer_letter_generated(applicant)
    @applicant = applicant

    mail :to => [ENV["ADMIN_EMAIL"], ENV["CFO_EMAIL"]], :subject => "[Footprints] An offer letter has been generated for #{applicant.name}"
  end

  def applicant_hired(applicant)
    @applicant = applicant
    crafter = Crafter.find_by_name(applicant.assigned_crafter)

    mail :to => [Rails.env.staging? ? ENV["TEST_EMAIL"] : crafter.email, ENV["ADMIN_EMAIL"], ENV["CFO_EMAIL"]], :subject => "[Footprints] A decision has been made on applicant #{applicant.name}"
  end

  def dispatcher_failed_to_assign_applicant(applicant, error)
    @applicant = applicant
    @error = error
    mail :to => ENV["FOOTPRINTS_TEAM"], :subject => "[Footprints] Dispatcher failed to assign applicant #{applicant.name}"
  end
end
