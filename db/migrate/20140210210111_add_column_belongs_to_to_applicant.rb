class AddColumnBelongsToToApplicant < ActiveRecord::Migration
  def change
    remove_column :applicants, :crafter_id
    add_reference :applicants, :crafter, index: true
  end
end
