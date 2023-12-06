class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :nickname, null: false, index: { unique: true }
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
