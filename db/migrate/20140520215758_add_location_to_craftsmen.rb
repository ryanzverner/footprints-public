class AddLocationToCraftsmen < ActiveRecord::Migration
  def change
    add_column :craftsmen, :location, :string, default: "Chicago"
  end
end
