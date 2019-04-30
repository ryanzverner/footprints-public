class RemoveCrafterNotificationTimeFromApplicant < ActiveRecord::Migration
  def change
    remove_column :applicants, :crafter_notification_time, :string
  end
end
