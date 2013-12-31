class RemoveCraftsmanNotificationTimeFromApplicant < ActiveRecord::Migration
  def change
    remove_column :applicants, :craftsman_notification_time, :string
  end
end
