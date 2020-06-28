class AddDistanceAndCreatorToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :distance_left, :integer, null: false
    add_reference :locations, :sender, foreign_key: {to_table: :users}, null: false
  end
end
