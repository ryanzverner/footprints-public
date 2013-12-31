class ChangeArchivedToDefaultToFalseOnApplicant < ActiveRecord::Migration
  def up
    change_column :applicants, :archived, :boolean, :default => false
  end

  def down
    change_column :applicants, :archived, :boolean
  end
end
