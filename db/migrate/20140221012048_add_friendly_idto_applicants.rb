class AddFriendlyIdtoApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :slug, :string
    add_index  :applicants, :slug, unique: true
  end
end
