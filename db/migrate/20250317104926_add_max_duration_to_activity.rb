class AddMaxDurationToActivity < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :max_duration, :integer, default: 0
  end
end
