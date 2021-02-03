class AddFieldToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string :username, null: false

      t.string :name, null: false
      t.string :middle_name, null: true
      t.string :last_name, null: false

      t.jsonb :meta, default: {}
    end

    add_index :users, :username, unique: true
  end
end
