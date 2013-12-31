class DropFriendlyId < ActiveRecord::Migration
  def down
    drop_table :friendly_id_slug
  end
end
