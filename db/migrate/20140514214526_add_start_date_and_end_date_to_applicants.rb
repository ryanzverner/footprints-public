class AddStartDateAndEndDateToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :start_date, :date
    add_column :applicants, :end_date, :date
  end
end
