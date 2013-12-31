class AddLocationToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :location, :string
  end
end
