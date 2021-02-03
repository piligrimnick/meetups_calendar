class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.belongs_to :user, null: false

      t.integer :activity_type, null: false

      t.string :title, null: false
      t.text :short_description, null: false, limit: 255

      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.jsonb :meta, default: {}

      t.timestamps
    end

    add_index :activities, :activity_type
  end
end
