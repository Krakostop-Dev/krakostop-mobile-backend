class CreatePairs < ActiveRecord::Migration[6.0]
  def change
    create_table :pairs do |t|
      t.boolean :finished, null: false, default: false
      t.integer :pair_nr, index: { unique: true }
      t.timestamps
    end
  end
end
