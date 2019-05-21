class AddUnavailableUntilToCrafters < ActiveRecord::Migration
  def change
    add_column :crafters, :unavailable_until, :date
  end
end
