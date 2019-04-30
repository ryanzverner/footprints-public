class AddHasApprenticeToCrafter < ActiveRecord::Migration
  def change
    add_column :crafters, :has_apprentice, :boolean, :null => false, :default => false
  end
end
