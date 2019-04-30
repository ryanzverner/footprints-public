class AddCrafterNotificationDateTimeToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :crafter_notification_time , :datetime
  end
end
