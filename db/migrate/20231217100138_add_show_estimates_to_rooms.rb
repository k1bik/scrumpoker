class AddShowEstimatesToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :show_estimates, :boolean, default: false
  end
end
