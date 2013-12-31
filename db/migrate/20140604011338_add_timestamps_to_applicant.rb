class AddTimestampsToApplicant < ActiveRecord::Migration
  def change
    add_column :applicants, :created_at, :datetime
    add_column :applicants, :updated_at, :datetime
  end
end
