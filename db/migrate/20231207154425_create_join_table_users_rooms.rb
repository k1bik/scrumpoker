class CreateJoinTableUsersRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :user_room_estimates, id: :uuid do |t|
      t.boolean :hidden, null: false, default: false
      t.string :value
      t.references :user, null: false, type: :uuid, foreign_key: { to_table: :users, type: :uuid }
      t.references :room, null: false, type: :uuid, foreign_key: { to_table: :rooms, type: :uuid }

      t.timestamps
    end
  end
end
