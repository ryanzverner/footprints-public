class ChangeCrafterEmploymentIdToInteger < ActiveRecord::Migration
  def up
    change_column :crafters, :employment_id, :integer
  end

  def down
    change_column :crafters, :employment_id, :string
  end
end
