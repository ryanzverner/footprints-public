class CreateAnnualStartingCraftsmanSalary < ActiveRecord::Migration
  def change
    create_table :annual_starting_craftsman_salaries do |t|
      t.string  :location, :null => false
      t.float   :amount,   :null => false
    end
  end
end
