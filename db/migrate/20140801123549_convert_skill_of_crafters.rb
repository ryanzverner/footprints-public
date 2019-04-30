class ConvertSkillOfCrafters < ActiveRecord::Migration
  class Crafters < ActiveRecord::Base
  end

  def up
    Crafters.find_each do |crafter|
      if crafter.skill.nil?
        crafter.skill = 1
      else
        crafter.skill = crafter.skill.downcase == 'resident' ? 2 : 1
      end

      crafter.save!
    end

    change_column :crafters, :skill, :tinyint, :default => 1, :null => false
  end

  def down
    change_column :crafters, :skill, :string, :default => nil, :null => true

    Crafters.find_each do |crafter|
      crafter.skill = crafter.skill == '1' ? 'Student' : 'Resident'
      crafter.save!
    end
  end
end
