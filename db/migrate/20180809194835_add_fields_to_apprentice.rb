class AddFieldsToApprentice < ActiveRecord::Migration
  def change
    add_column :apprentices, :name, :string
    add_column :apprentices, :applied_on, :date
    add_column :apprentices, :email, :string
    add_column :apprentices, :hired, :string
    add_column :apprentices, :location, :string
    add_column :apprentices, :archived, :boolean
    add_column :apprentices, :position, :string
    add_column :apprentices, :start_date, :date
    add_column :apprentices, :end_date, :date
    add_column :apprentices, :mentor, :string
  end
end
