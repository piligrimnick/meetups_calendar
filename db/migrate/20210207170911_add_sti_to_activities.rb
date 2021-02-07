
class AddStiToActivities < ActiveRecord::Migration[6.1]
  ACTIVITY_TYPES = {
    "internal_meetup" => 0,
    "public_meetup" => 1,
    "speech_draft" => 2,
    "conference_speech" => 3,
    "hackathon" => 4
  }.freeze

  ACTIVITY_TYPES_VALUES = Arel::Nodes::ValuesList.new(ACTIVITY_TYPES.transform_keys(&:classify)).to_sql

  def up
    add_column :activities, :type, :string

    execute <<-SQL
      UPDATE activities as a SET type = v.class_name
      FROM (#{ACTIVITY_TYPES_VALUES})
      AS v(class_name, enum)
      WHERE v.enum = a.activity_type
    SQL

    change_column :activities, :type, :string, null: false

    remove_column :activities, :activity_type
  end

  def down
    add_column :activities, :activity_type, :integer

    execute <<-SQL
      UPDATE activities as a SET activity_type = v.enum
      FROM (#{ACTIVITY_TYPES_VALUES})
      AS v(class_name, enum)
      WHERE v.class_name = a.type
    SQL

    change_column :activities, :activity_type, :integer, null: false

    remove_column :activities, :type

    add_index :activities, :activity_type
  end
end
