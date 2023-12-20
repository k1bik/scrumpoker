class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms, id: :uuid do |t|
      t.string :name, null: false
      t.string :estimates, null: false
      t.boolean :is_estimates_hidden, null: false, default: false
      t.jsonb :statistics, null: false, default: {}
      t.references :owner, null: false, type: :uuid, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
