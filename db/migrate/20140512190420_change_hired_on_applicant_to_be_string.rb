class ChangeHiredOnApplicantToBeString < ActiveRecord::Migration
  def up
    change_column :applicants, :hired, :string, :default => "no_decision"
  end

  def down
    change_column :applicants, :hired, :boolean, :default => nil
  end
end
