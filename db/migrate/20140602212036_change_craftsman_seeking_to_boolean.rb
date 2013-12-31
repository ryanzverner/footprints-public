class ChangeCraftsmanSeekingToBoolean < ActiveRecord::Migration
  def change
    add_column :craftsmen, :seeking_tmp, :boolean, :default => false
    add_column :craftsmen, :skill, :string
    Craftsman.reset_column_information
    Craftsman.all.each do |craftsman|
      craftsman.seeking_tmp = craftsman.seeking == "not_seeking" ? false : true
      craftsman.skill = craftsman.seeking unless craftsman.seeking == "not_seeking"
      craftsman.save
    end
    remove_column :craftsmen, :seeking
    rename_column :craftsmen, :seeking_tmp, :seeking
  end
end
