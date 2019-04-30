module Footprints
  class Reminder
    class << self

      def notify_crafter_of_outstanding_requests
        Applicant.not_archived.each do |applicant|
          mail_crafter(applicant) if applicant.outstanding?(1)
          mail_steward(applicant) if steward_needs_notification?(applicant)
        end
      end

      def mail_crafter(applicant)
        NotificationMailer.crafter_reminder(applicant).deliver
        Notification.create(:applicant => applicant, :crafter => applicant.crafter)
      end

      def mail_steward(applicant)
        NotificationMailer.steward_reminder(applicant).deliver
        Notification.create(:applicant => applicant, :crafter => @steward)
      end

      def steward_needs_notification?(applicant)
        applicant.outstanding?(2) && !steward_notified?(applicant)
      end

      def steward_notified?(applicant)
        @steward = Crafter.find_by_email(ENV["STEWARD"])
        Notification.where(:applicant => applicant, :crafter => @steward).present?
      end

    end
  end
end
