class AddMaterialToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :material, :string
  end
end
