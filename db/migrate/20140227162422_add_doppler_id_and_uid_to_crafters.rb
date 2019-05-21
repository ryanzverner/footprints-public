class AddDopplerIdAndUidToCrafters < ActiveRecord::Migration
  def change
    add_column :crafters, :doppler_id, :string
    add_column :crafters, :uid, :string
  end
end
