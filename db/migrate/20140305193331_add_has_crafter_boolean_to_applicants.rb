class AddHasCrafterBooleanToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :has_crafter, :boolean
  end
end
