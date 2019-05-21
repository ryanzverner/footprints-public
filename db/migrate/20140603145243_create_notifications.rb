class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :applicant_id
      t.integer :crafter_id

      t.timestamps
    end
  end
end
