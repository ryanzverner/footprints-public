class RemoveSlugIndexFromApplicants < ActiveRecord::Migration
  def down
    remove_index :applicants, :slug
  end
end
