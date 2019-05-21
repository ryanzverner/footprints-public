class AddHasSupportMentorToCrafter < ActiveRecord::Migration
  def change
    add_column :crafters, :has_support_mentor, :boolean, :null => false, :default => false
  end
end
