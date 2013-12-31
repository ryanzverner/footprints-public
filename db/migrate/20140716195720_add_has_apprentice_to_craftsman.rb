class AddHasApprenticeToCraftsman < ActiveRecord::Migration
  def change
    add_column :craftsmen, :has_apprentice, :boolean, :null => false, :default => false
  end
end
