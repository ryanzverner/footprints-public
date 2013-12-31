class RemoveStateFromApplicant < ActiveRecord::Migration
  def change
    remove_column :applicants, :state, :string
  end
end
