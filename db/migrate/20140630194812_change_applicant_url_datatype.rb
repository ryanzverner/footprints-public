class ChangeApplicantUrlDatatype < ActiveRecord::Migration
  def change
    change_column :applicants, :url, :text
  end
end
