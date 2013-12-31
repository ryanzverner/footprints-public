class RenameHasCraftsmanToHasStewardInApplicant < ActiveRecord::Migration
  def change
    rename_column :applicants, :has_craftsman, :has_steward
  end
end
