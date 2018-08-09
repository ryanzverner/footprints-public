class CreateApprentices < ActiveRecord::Migration
  def change
    create_table :apprentices do |t|

      t.timestamps
    end
  end
end
