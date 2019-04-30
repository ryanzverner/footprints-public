class AddSeekingApprenticeFieldToCrafters < ActiveRecord::Migration
  def change
    add_column :crafters, :seeking, :string, :default => "not_seeking"
  end
end
