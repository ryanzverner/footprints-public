class DropFriendlyIdSlugs < ActiveRecord::Migration
  def down
    drop_table :friendly_id_slugs
  end
end
