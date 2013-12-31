class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :applicant, index: true
      t.text :body
      t.date :created_at
      t.string :title
      t.timestamps
    end
  end
end
