class AddCraftsmanIdToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :craftsman_id, :integer
  end
end
