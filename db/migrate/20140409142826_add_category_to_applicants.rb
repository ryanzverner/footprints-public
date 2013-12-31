class AddCategoryToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :skill, :string
    add_column :applicants, :discipline, :string
  end
end
