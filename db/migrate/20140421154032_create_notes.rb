class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :body
      t.integer :craftsman_id
      t.integer :applicant_id
      t.timestamps
    end
  end
end
