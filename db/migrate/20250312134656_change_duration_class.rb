class ChangeDurationClass < ActiveRecord::Migration[7.1]
  def change
    change_column :activities, :duration, :string
  end
end
