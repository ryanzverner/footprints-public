class AddCraftsmanNotificationDateTimeToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :craftsman_notification_time , :datetime
  end
end
