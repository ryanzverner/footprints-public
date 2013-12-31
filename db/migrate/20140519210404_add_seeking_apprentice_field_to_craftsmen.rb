class AddSeekingApprenticeFieldToCraftsmen < ActiveRecord::Migration
  def change
    add_column :craftsmen, :seeking, :string, :default => "not_seeking"
  end
end
