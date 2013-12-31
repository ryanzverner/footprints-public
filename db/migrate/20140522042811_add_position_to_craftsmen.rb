class AddPositionToCraftsmen < ActiveRecord::Migration
  def change
    add_column :craftsmen, :position, :string
  end
end
