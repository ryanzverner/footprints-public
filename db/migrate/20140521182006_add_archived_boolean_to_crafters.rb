class AddArchivedBooleanToCrafters < ActiveRecord::Migration
  def change
    add_column :crafters, :archived, :boolean, default: false
  end
end
