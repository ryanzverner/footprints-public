class ConvertSkillOfCraftsmen < ActiveRecord::Migration
  class Craftsmen < ActiveRecord::Base
  end

  def up
    Craftsmen.find_each do |craftsman|
      if craftsman.skill.nil?
        craftsman.skill = 1
      else
        craftsman.skill = craftsman.skill.downcase == 'resident' ? 2 : 1
      end

      craftsman.save!
    end

    change_column :craftsmen, :skill, :tinyint, :default => 1, :null => false
  end

  def down
    change_column :craftsmen, :skill, :string, :default => nil, :null => true

    Craftsmen.find_each do |craftsman|
      craftsman.skill = craftsman.skill == '1' ? 'Student' : 'Resident'
      craftsman.save!
    end
  end
end
