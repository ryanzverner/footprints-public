class ChangeDopplerIdToEmploymentIdOnCraftsmen < ActiveRecord::Migration
  def change
    rename_column :craftsmen, :doppler_id, :employment_id
  end
end
