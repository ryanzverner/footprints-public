class AddLocationToCrafters < ActiveRecord::Migration
  def change
    add_column :crafters, :location, :string, default: "Chicago"
  end
end
