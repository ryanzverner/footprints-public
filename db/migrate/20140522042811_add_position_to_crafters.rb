class AddPositionToCrafters < ActiveRecord::Migration
  def change
    add_column :crafters, :position, :string
  end
end
