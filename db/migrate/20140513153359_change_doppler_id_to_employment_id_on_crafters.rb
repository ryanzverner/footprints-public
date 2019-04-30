class ChangeDopplerIdToEmploymentIdOnCrafters < ActiveRecord::Migration
  def change
    rename_column :crafters, :doppler_id, :employment_id
  end
end
