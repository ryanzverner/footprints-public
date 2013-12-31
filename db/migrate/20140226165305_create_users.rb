class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "login"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "email"
      t.string "uid"
      t.string "provider"
      t.integer "craftsman_id"
    end
  end
end
