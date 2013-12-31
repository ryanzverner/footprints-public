class AddArchivedToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :archived, :boolean, :default => false
  end
end
