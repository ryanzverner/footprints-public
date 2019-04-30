class AddCrafterIdToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :crafter_id, :integer
  end
end
