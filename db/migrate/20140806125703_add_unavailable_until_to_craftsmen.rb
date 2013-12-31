class AddUnavailableUntilToCraftsmen < ActiveRecord::Migration
  def change
    add_column :craftsmen, :unavailable_until, :date
  end
end
