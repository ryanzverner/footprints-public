class ChangeCrafterSeekingToBoolean < ActiveRecord::Migration
  def change
    add_column :crafters, :seeking_tmp, :boolean, :default => false
    add_column :crafters, :skill, :string
    Crafter.reset_column_information
    Crafter.all.each do |crafter|
      crafter.seeking_tmp = crafter.seeking == "not_seeking" ? false : true
      crafter.skill = crafter.seeking unless crafter.seeking == "not_seeking"
      crafter.save
    end
    remove_column :crafters, :seeking
    rename_column :crafters, :seeking_tmp, :seeking
  end
end
