class AddArchivedBooleanToCraftsmen < ActiveRecord::Migration
  def change
    add_column :craftsmen, :archived, :boolean, default: false
  end
end
