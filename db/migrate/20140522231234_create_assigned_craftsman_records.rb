class CreateAssignedCraftsmanRecords < ActiveRecord::Migration
  def change
    create_table :assigned_craftsman_records do |t|
      t.integer :applicant_id
      t.integer :craftsman_id
      t.boolean :current, :default => true

      t.timestamps
    end
  end
end
