class AddApplicationColumnsToApplicant < ActiveRecord::Migration
  def change
    add_column :applicants, :about, :text
    add_column :applicants, :software_interest, :text
    add_column :applicants, :reason, :text
  end
end
