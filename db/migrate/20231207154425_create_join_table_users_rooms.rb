class CreateJoinTableUsersRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :user_rooms, id: :uuid do |t|
      t.references :user, null: false, type: :uuid, foreign_key: { to_table: :users, type: :uuid }
      t.references :room, null: false, type: :uuid, foreign_key: { to_table: :rooms, type: :uuid }
      t.string :estimate

      t.timestamps
    end
  end
end
