class AddReferenceToApplicants < ActiveRecord::Migration
  def change
    remove_column :applicants, :craftsman_id
    add_reference :applicants, :craftsman, index: true
  end
end
