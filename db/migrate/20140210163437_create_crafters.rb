class CreateCrafters < ActiveRecord::Migration
  def change
    create_table :crafters do |t|
      t.string :name
      t.string :status
    end
  end
end
