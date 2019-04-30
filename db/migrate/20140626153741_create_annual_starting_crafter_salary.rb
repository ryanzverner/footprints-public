class CreateAnnualStartingCrafterSalary < ActiveRecord::Migration
  def change
    create_table :annual_starting_crafter_salaries do |t|
      t.string  :location, :null => false
      t.float   :amount,   :null => false
    end
  end
end
