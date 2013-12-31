class ChangeCraftsmanEmploymentIdToInteger < ActiveRecord::Migration
  def up
    change_column :craftsmen, :employment_id, :integer
  end

  def down
    change_column :craftsmen, :employment_id, :string
  end
end
