class CreateCraftsmen < ActiveRecord::Migration
  def change
    create_table :craftsmen do |t|
      t.string :name
      t.string :status
    end
  end
end
