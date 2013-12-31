class AddHasCraftsmanBooleanToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :has_craftsman, :boolean
  end
end
