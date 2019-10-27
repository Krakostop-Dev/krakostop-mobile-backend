class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.decimal :lat,  precision: 15, scale: 10, null: false
      t.decimal :lng,  precision: 15, scale: 10, null: false
      t.references :user, null: false
      t.timestamps
    end

    add_index :locations, [:lat, :lng]
  end
end
