class AddMentorToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :mentor, :string, after: :end_date
  end
end
