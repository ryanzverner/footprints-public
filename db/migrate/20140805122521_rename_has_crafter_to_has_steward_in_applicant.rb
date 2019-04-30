class RenameHasCrafterToHasStewardInApplicant < ActiveRecord::Migration
  def change
    rename_column :applicants, :has_crafter, :has_steward
  end
end
