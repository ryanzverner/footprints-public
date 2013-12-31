class AddEmailToCraftsmen < ActiveRecord::Migration
  def change
    add_column :craftsmen, :email, :string
  end
end
