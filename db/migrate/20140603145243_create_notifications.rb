class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :applicant_id
      t.integer :craftsman_id

      t.timestamps
    end
  end
end
