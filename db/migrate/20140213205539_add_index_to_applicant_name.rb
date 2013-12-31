class AddIndexToApplicantName < ActiveRecord::Migration
  def change
    add_index :applicants, :name
  end
end
