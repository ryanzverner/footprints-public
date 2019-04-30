class AddEmailToCrafters < ActiveRecord::Migration
  def change
    add_column :crafters, :email, :string
  end
end
