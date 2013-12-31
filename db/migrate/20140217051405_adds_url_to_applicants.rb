class AddsUrlToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :url, :string
  end
end
