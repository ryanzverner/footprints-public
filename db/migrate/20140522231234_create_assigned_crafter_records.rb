class CreateAssignedCrafterRecords < ActiveRecord::Migration
  def change
    create_table :assigned_crafter_records do |t|
      t.integer :applicant_id
      t.integer :crafter_id
      t.boolean :current, :default => true

      t.timestamps
    end
  end
end
