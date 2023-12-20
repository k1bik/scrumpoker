class AddHiddenToUserRoom < ActiveRecord::Migration[7.1]
  def change
    add_column :user_rooms, :hidden, :boolean, default: false
  end
end
