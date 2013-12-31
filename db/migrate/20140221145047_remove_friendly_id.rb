class RemoveFriendlyId < ActiveRecord::Migration
  def down
    remove_column :applicants, :slug
    remove_index :applicants, :slug
  end
end
