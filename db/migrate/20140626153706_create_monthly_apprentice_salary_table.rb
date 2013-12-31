class CreateMonthlyApprenticeSalaryTable < ActiveRecord::Migration
  def change
    create_table :monthly_apprentice_salaries do |t|
      t.integer :duration, :null => false
      t.string  :location, :null => false
      t.float   :amount,   :null => false
    end
  end
end
