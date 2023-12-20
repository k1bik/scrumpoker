class AddStatisticsToRoom < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :statistics, :jsonb
  end
end
